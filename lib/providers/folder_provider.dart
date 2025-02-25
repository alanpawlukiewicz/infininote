import 'package:flutter/material.dart';
import 'package:infininote/data/folder_colors.dart';
import 'package:infininote/models/folder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  bool isBeingCreated = false;
  final db = await sql.openDatabase(
    path.join(dbPath, 'folders.db'),
    onCreate: (db, version) async {
      isBeingCreated = true;
      await db.execute(
          'CREATE TABLE user_folders(id TEXT PRIMARY KEY, name TEXT, color TEXT)');
      return db.execute(
          'CREATE TABLE user_notes(id TEXT PRIMARY KEY, title TEXT, contents TEXT, creationDate DATETIME, modificationDate DATETIME, folderId TEXT, FOREIGN KEY(folderId) REFERENCES user_folders(id))');
    },
    version: 8,
  );
  if (isBeingCreated) {
    await db.rawInsert(
        'INSERT INTO user_folders(id, name, color) VALUES(?, ?, ?)',
        ['123', 'Main Folder', 'Grey']);
  }
  return db;
}

class FolderNotifier extends StateNotifier<List<Folder>> {
  FolderNotifier() : super([]);

  bool firstTime = true;

  Future<void> loadData(WidgetRef ref) async {
    final db = await _getDatabase();
    final data = await db.query('user_folders');
    final folders = data.map((row) {
      final Color color = folderColors[row['color'] as String] as Color;
      return Folder.load(
        name: row['name'] as String,
        color: color,
        id: row['id'] as String,
      );
    }).toList();

    if (firstTime) {
      ref.read(folderIdProvider.notifier).setId(folders[0].id);
      firstTime = false;
    }

    state = folders;
  }

  void addFolder(Folder folder) async {
    state = [folder, ...state];

    final db = await _getDatabase();
    db.insert('user_folders', {
      'id': folder.id,
      'name': folder.name,
      'color': folder.colorKey,
    });
  }

  Future<Folder> updateFolder(Folder oldFolder, Folder updatedFolder) async {
    final db = await _getDatabase();

    Folder newFolder = Folder.load(
      name: updatedFolder.name,
      color: updatedFolder.color,
      id: oldFolder.id,
    );

    await db.rawUpdate('''
    UPDATE user_folders 
    SET name = ?, color = ?
    WHERE id = ?
    ''', [updatedFolder.name, updatedFolder.colorKey, oldFolder.id]);

    state = [
      newFolder,
      ...state.where(
        (element) {
          return element != oldFolder;
        },
      )
    ];

    return newFolder;
  }

  void removeFolder(Folder folder) async {
    state = [
      ...state.where(
        (element) {
          return element != folder;
        },
      )
    ];

    final db = await _getDatabase();
    db.rawDelete('DELETE FROM user_folders WHERE id = ?', [folder.id]);
    final dbPath = await sql.getDatabasesPath();
    final noteDb = await sql.openDatabase(
      path.join(dbPath, 'folders.db'),
      version: 1,
    );
    noteDb.rawDelete('DELETE FROM user_notes WHERE folderId = ?', [folder.id]);
  }

  Future<void> truncateTable(WidgetRef ref) async {
    final db = await _getDatabase();
    await db.rawDelete('DELETE FROM user_folders');
    await db.rawInsert(
        'INSERT INTO user_folders(id, name, color) VALUES(?, ?, ?)',
        ['123', 'Main Folder', 'Grey']);

    final data = await db.query('user_folders');
    final folders = data.map((row) {
      final Color color = folderColors[row['color'] as String] as Color;
      return Folder.load(
        name: row['name'] as String,
        color: color,
        id: row['id'] as String,
      );
    }).toList();
    ref.read(folderIdProvider.notifier).setId(folders[0].id);

    state = folders;
  }
}

final folderProvider =
    StateNotifierProvider<FolderNotifier, List<Folder>>((ref) {
  return FolderNotifier();
});

class FolderIdNotifier extends StateNotifier<String> {
  FolderIdNotifier() : super('123');

  Future<void> setId(fId) async {
    state = fId;
  }
}

final folderIdProvider = StateNotifierProvider<FolderIdNotifier, String>((ref) {
  return FolderIdNotifier();
});

final currentFolderProvider = Provider<Folder>(
  (ref) {
    final currentFolder = ref.watch(folderProvider).where(
      (folder) {
        return folder.id == ref.watch(folderIdProvider);
      },
    ).toList()[0];
    return currentFolder;
  },
);
