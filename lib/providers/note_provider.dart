import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:infininote/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/providers/folder_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'folders.db'),
    version: 8,
  );
  return db;
}

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]);

  Future<void> loadData() async {
    final db = await _getDatabase();
    final data = await db.query('user_notes');
    final notes = data.map((row) {
      return Note.load(
        title: row['title'] as String,
        contents: json.decode(row['contents'] as String),
        id: row['id'] as String,
        folderId: row['folderId'] as String,
        creationDate: formatter.parse(row['creationDate'] as String),
        modificationDate: formatter.parse(row['modificationDate'] as String),
      );
    }).toList();

    state = notes.reversed.toList();
  }

  void addNote(Note newNote) async {
    state = [newNote, ...state];

    final db = await _getDatabase();
    await db.insert('user_notes', {
      'id': newNote.id,
      'title': newNote.title,
      'contents': newNote.encodedContents,
      'folderId': newNote.folderId,
      'creationDate': formatter.format(newNote.creationDate),
      'modificationDate': formatter.format(newNote.modificationDate),
    });
  }

  void updateNote(Note oldNote, Note updatedNote) async {
    state = [
      updatedNote,
      ...state.where(
        (element) {
          return element != oldNote;
        },
      )
    ];

    final db = await _getDatabase();
    await db.rawUpdate('''
    UPDATE user_notes 
    SET title = ?, contents = ?, folderId = ?, modificationDate = ?, creationDate = ?
    WHERE id = ?
    ''', [
      updatedNote.title,
      updatedNote.encodedContents,
      updatedNote.folderId,
      formatter.format(DateTime.now()),
      formatter.format(oldNote.creationDate),
      oldNote.id,
    ]);
  }

  void removeNote(Note note) async {
    state = [
      ...state.where(
        (element) {
          return element != note;
        },
      )
    ];

    final db = await _getDatabase();
    db.rawDelete('DELETE FROM user_notes WHERE id = ?', [note.id]);
  }

  Future<void> truncateTable() async {
    state = [];

    final db = await _getDatabase();
    db.rawDelete('DELETE FROM user_notes');
  }
}

final notesFromFolderProvider = Provider<List<Note>>(
  (ref) {
    return ref.watch(noteProvider).where(
      (element) {
        return element.folderId == ref.watch(currentFolderProvider).id;
      },
    ).toList();
  },
);

final noteProvider = StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
  return NoteNotifier();
});
