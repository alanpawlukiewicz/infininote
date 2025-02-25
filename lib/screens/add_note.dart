import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/models/note.dart';
import 'package:infininote/providers/folder_provider.dart';

import 'package:infininote/providers/note_provider.dart';
import 'package:infininote/widgets/custon_textfield.dart';
import 'package:infininote/widgets/editor.dart';
import 'package:infininote/widgets/toolbar.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({super.key});

  @override
  ConsumerState<AddNoteScreen> createState() {
    return _AddNoteScreenState();
  }
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final _quillController = QuillController.basic();
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateTitle(String? value) {
    if (_titleController.text.trim().isEmpty) {
      return 'Please enter title.';
    }
    return null;
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final contents = _quillController.document.toDelta().toJson();
    final currentFolder = ref.read(currentFolderProvider);
    ref.read(noteProvider.notifier).addNote(
          Note(
              title: _titleController.text,
              contents: contents,
              folderId: currentFolder.id),
        );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _quillController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Note"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _titleController,
                    hintText: 'Title',
                    validator: (value) => _validateTitle(value),
                  ),
                  Toolbar(controller: _quillController),
                  Editor(controller: _quillController),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: _saveNote,
                        label: const Text('Add new note'),
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
