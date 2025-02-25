import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:infininote/models/note.dart';
import 'package:infininote/providers/note_provider.dart';
import 'package:infininote/widgets/editor.dart';
import 'package:infininote/widgets/expandable_appbar.dart';
import 'package:infininote/widgets/toolbar.dart';

class NoteDescriptionScreen extends ConsumerStatefulWidget {
  const NoteDescriptionScreen({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  ConsumerState<NoteDescriptionScreen> createState() {
    return _NoteDescriptionScreenState();
  }
}

class _NoteDescriptionScreenState extends ConsumerState<NoteDescriptionScreen> {
  late final QuillController _quillController;
  final _titleController = TextEditingController();

  void _updateNote() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note title cannot be empty.'),
        ),
      );
      return;
    }
    final List<dynamic> newContents =
        _quillController.document.toDelta().toJson();

    if (newContents.toString() == widget.note.contents.toString() &&
        _titleController.text.trim() == widget.note.title.trim()) {
      Navigator.of(context).pop();
      return;
    }
    ref.read(noteProvider.notifier).updateNote(
        widget.note,
        Note(
          title: _titleController.text,
          contents: newContents,
          folderId: widget.note.folderId,
          newCreationDate: widget.note.creationDate,
        ));
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _quillController = QuillController(
      document: Document.fromJson(widget.note.contents),
      selection: TextSelection.collapsed(offset: 0),
    );
    _titleController.text = widget.note.title;
  }

  @override
  void dispose() {
    _quillController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExpandableAppBar(
          note: widget.note,
          titleController: _titleController,
          onDismiss: _updateNote),
      body: Column(
        children: [
          Toolbar(controller: _quillController),
          Editor(controller: _quillController),
        ],
      ),
    );
  }
}
