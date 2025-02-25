import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/models/note.dart';
import 'package:infininote/providers/note_provider.dart';
import 'package:infininote/widgets/empty_state.dart';
import 'package:infininote/widgets/note_widgets/note_list_tile.dart';
import 'package:infininote/widgets/note_widgets/wrapped_note_tile.dart';

class NoteView extends ConsumerWidget {
  const NoteView({
    super.key,
    required this.sortedNotes,
    required this.isListView,
  });

  final List<Note> sortedNotes;
  final bool isListView;

  void _onDeleteCancel(WidgetRef ref, Note note) {
    ref.read(noteProvider.notifier).addNote(
          Note(
            title: note.title,
            contents: note.contents,
            folderId: note.folderId,
            newCreationDate: note.creationDate,
          ),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget displayedWidget = const EmptyState();
    if (sortedNotes.isNotEmpty && isListView == false) {
      displayedWidget = GridView.builder(
        itemCount: sortedNotes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
        ),
        itemBuilder: (context, index) => WrappedNoteTile(
          note: sortedNotes[index],
          onDeleteCancel: () => _onDeleteCancel(ref, sortedNotes[index]),
        ),
      );
    }
    if (sortedNotes.isNotEmpty && isListView == true) {
      displayedWidget = ListView.builder(
        itemCount: sortedNotes.length,
        itemBuilder: (ctx, index) => NoteListTile(
          note: sortedNotes[index],
          onDeleteCancel: () => _onDeleteCancel(ref, sortedNotes[index]),
        ),
      );
    }

    return Expanded(child: displayedWidget);
  }
}
