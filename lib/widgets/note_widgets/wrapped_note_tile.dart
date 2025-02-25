import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/models/note.dart';
import 'package:infininote/providers/note_provider.dart';
import 'package:infininote/screens/note_description.dart';
import 'package:infininote/widgets/notification_widgets/notification_modal_bottom_sheet.dart';

class WrappedNoteTile extends ConsumerStatefulWidget {
  const WrappedNoteTile({
    super.key,
    required this.note,
    required this.onDeleteCancel,
  });

  final Note note;
  final Function() onDeleteCancel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WrappedNoteTileState();
}

class _WrappedNoteTileState extends ConsumerState<WrappedNoteTile> {
  Offset _tapPosition = Offset.zero;
  bool isHighlighted = false;

  void _highlight(bool highlight) {
    setState(() {
      isHighlighted = highlight;
    });
  }

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

  void _checkContents(Note note) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NoteDescriptionScreen(note: note),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isHighlighted
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1)
                      : (Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : const Color.fromARGB(255, 17, 17, 17)),
                ),
                width: double.infinity,
                child: Text(
                  widget.note.plainText,
                  maxLines: 11,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: () => _checkContents(widget.note),
              onTapDown: (position) => _getTapPosition(position),
              onLongPressStart: (_) => _highlight(false),
              onLongPressCancel: () => _highlight(false),
              onLongPressDown: (_) => _highlight(true),
              onLongPress: () => _showContextMenu(context),
            ),
          ),
          Column(
            children: [
              Text(
                widget.note.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(widget.note.formattedCreationDate),
            ],
          ),
        ],
      ),
    );
  }
}
