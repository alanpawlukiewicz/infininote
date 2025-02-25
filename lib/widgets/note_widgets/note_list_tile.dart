import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/models/note.dart';
import 'package:infininote/providers/note_provider.dart';
import 'package:infininote/screens/note_description.dart';
import 'package:infininote/widgets/notification_widgets/notification_modal_bottom_sheet.dart';

class NoteListTile extends ConsumerStatefulWidget {
  const NoteListTile({
    super.key,
    required this.note,
    required this.onDeleteCancel,
  });

  final Note note;
  final Function() onDeleteCancel;

  @override
  ConsumerState<NoteListTile> createState() => _NoteListTileState();
}

class _NoteListTileState extends ConsumerState<NoteListTile> {
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition) {
    setState(() {
      _tapPosition = tapPosition.globalPosition;
    });
  }

  void _showContextMenu(context) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    final result = await showMenu(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      position: RelativeRect.fromRect(
        Rect.fromLTWH(
          _tapPosition.dx,
          _tapPosition.dy,
          10,
          10,
        ),
        Rect.fromLTWH(
          0,
          0,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      items: [
        const PopupMenuItem(
          value: 'reminder',
          child: Row(
            children: [
              Icon(Icons.alarm),
              SizedBox(width: 8),
              Text('Set Reminder')
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'info',
          child: Row(
            children: [
              Icon(Icons.info),
              SizedBox(width: 8),
              Text('Show information')
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text('Delete note')
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'close',
          child: Row(
            children: [Icon(Icons.close), SizedBox(width: 8), Text('Close')],
          ),
        ),
      ],
    );

    if (result == 'reminder') {
      showModalBottomSheet(
        context: context,
        builder: (context) => NotificationModalBottomSheet(note: widget.note),
      );
    }
    if (result == 'info') {
      showModalBottomSheet(
        context: context,
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          maxWidth: double.infinity,
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.today),
                  SizedBox(width: 8),
                  Text(
                      'Creation date: ${widget.note.formattedCreationDateTime}'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.edit_calendar),
                  SizedBox(width: 8),
                  Text(
                      'Last modification: ${widget.note.formattedModificationDateTime}'),
                ],
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
      );
    }
    if (result == 'delete') {
      _deleteNote();
    }
    if (result == 'close') {
      return;
    }
  }

  void _checkContents(Note note) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NoteDescriptionScreen(note: note),
    ));
  }

  void _deleteNote() {
    ref.read(noteProvider.notifier).removeNote(widget.note);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note has been removed.'),
        duration: Duration(seconds: 8),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: widget.onDeleteCancel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Dismissible(
        key: ValueKey(widget.note.id),
        onDismissed: (direction) => _deleteNote(),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8.0,
          ),
          child: GestureDetector(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onTap: () => _checkContents(widget.note),
              title: Text(widget.note.title),
              subtitle: Text(
                widget.note.plainText,
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              tileColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : const Color.fromARGB(255, 17, 17, 17),
            ),
            onTapDown: (position) => _getTapPosition(position),
            onLongPress: () => _showContextMenu(context),
          ),
        ),
      ),
    );
  }
}
