import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/models/folder.dart';
import 'package:infininote/models/note.dart';
import 'package:infininote/providers/folder_provider.dart';
import 'package:infininote/providers/note_provider.dart';
import 'package:infininote/providers/theme_provider.dart';
import 'package:infininote/screens/add_note.dart';
import 'package:infininote/widgets/empty_state.dart';
import 'package:infininote/widgets/main_drawer.dart';
import 'package:infininote/widgets/note_widgets/note_view.dart';
import 'package:infininote/widgets/sort_menu.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  late Future<void> _loadedFutures;
  Future<void> loadFutures() async {
    await ref.read(themeProvider.notifier).loadTheme();
    await ref.read(folderProvider.notifier).loadData(ref);
    await ref.read(noteProvider.notifier).loadData();
  }

  @override
  void initState() {
    super.initState();
    _loadedFutures = loadFutures();
  }

  List<Note> _sortNotes(
      List<Note> notes, String sortCondition, bool ascending) {
    final n = notes;
    if (sortCondition == 'creation_date' && ascending == false) {
      n.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    } else if (sortCondition == 'creation_date' && ascending == true) {
      notes.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    } else if (sortCondition == 'title' && ascending == false) {
      n.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    } else if (sortCondition == 'title' && ascending == true) {
      n.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else if (sortCondition == 'modification_date' && ascending == false) {
      n.sort((a, b) => b.modificationDate.compareTo(a.modificationDate));
    } else if (sortCondition == 'modification_date' && ascending == true) {
      notes.sort((a, b) => a.modificationDate.compareTo(b.modificationDate));
    }
    return n;
  }

  String _sortCondition = 'modification_date';
  bool _ascending = false;
  bool _isList = true;

  @override
  Widget build(BuildContext context) {
    List<Folder> folders = ref.watch(folderProvider);

    Widget displayedWidget = const EmptyState();

    return FutureBuilder(
      future: _loadedFutures,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else {
          FlutterNativeSplash.remove();
          Folder currentFolder = ref.watch(currentFolderProvider);
          List<Note> notes = ref.watch(notesFromFolderProvider);
          List<Note> sortedNotes =
              _sortNotes(notes, _sortCondition, _ascending);

          displayedWidget = Column(
            children: [
              if (sortedNotes.isNotEmpty)
                SortMenu(
                  onSortChange: (value, asc) {
                    setState(() {
                      _sortCondition = value;
                      _ascending = asc;
                    });
                  },
                  onLayoutChange: () {
                    setState(() {
                      _isList = !_isList;
                    });
                  },
                ),
              NoteView(sortedNotes: sortedNotes, isListView: _isList),
            ],
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(currentFolder.name),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddNoteScreen(),
                    ));
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            drawer: MainDrawer(
              folders: folders,
            ),
            body: displayedWidget,
          );
        }
      },
    );
  }
}
