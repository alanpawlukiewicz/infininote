import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/data/folder_colors.dart';
import 'package:infininote/models/folder.dart';
import 'package:infininote/providers/folder_provider.dart';
import 'package:infininote/widgets/custon_textfield.dart';
import 'package:infininote/screens/notes.dart';

class AddFolderScreen extends ConsumerStatefulWidget {
  const AddFolderScreen({
    super.key,
    this.editedFolder,
  });

  final Folder? editedFolder;

  @override
  ConsumerState<AddFolderScreen> createState() {
    return _AddFolderScreenState();
  }
}

class _AddFolderScreenState extends ConsumerState<AddFolderScreen> {
  final _nameController = TextEditingController();
  Color _chosenColor = folderColors.entries.first.value;
  bool _firstTimeChanging = true;
  final _formKey = GlobalKey<FormState>();

  String? _validateTitle(String? value) {
    if (_nameController.text.trim().isEmpty) {
      return 'Please enter folder name.';
    }
    return null;
  }

  void _addFolder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newFolder = Folder(name: _nameController.text, color: _chosenColor);
    ref.read(folderProvider.notifier).addFolder(newFolder);
    ref.read(folderIdProvider.notifier).setId(newFolder.id);

    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  void _updateFolder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newFolder = Folder(name: _nameController.text, color: _chosenColor);
    final Folder updatedFolder = await ref
        .read(folderProvider.notifier)
        .updateFolder(widget.editedFolder!, newFolder);
    await ref.read(folderIdProvider.notifier).setId(updatedFolder.id);
    if (context.mounted) {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
    }
  }

  void _removeFolder() {
    if (ref.read(folderProvider).length <= 1) {
      return;
    }

    ref.read(folderProvider.notifier).removeFolder(widget.editedFolder!);

    Folder firstFolder = ref.read(folderProvider)[0];
    ref.read(folderIdProvider.notifier).setId(firstFolder.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const NotesScreen();
        },
      ),
    );
  }

  Future<void> _showRemoveDialog(BuildContext context) {
    if (ref.read(folderProvider).length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You cannot remove your only folder.")),
      );
      return Future<bool>.value(true);
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Delete Folder',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          content: const Text(
              'Are you sure you want to delete this folder, including notes?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _removeFolder();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Folder has been removed.')),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              child: const Text('Delete Folder'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.editedFolder != null) {
      _nameController.text = widget.editedFolder!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editedFolder != null && _firstTimeChanging) {
      _chosenColor = widget.editedFolder!.color;
      _firstTimeChanging = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editedFolder == null
            ? "Add new Folder"
            : "Edit ${widget.editedFolder!.name}"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: 'Folder Name',
                validator: (value) => _validateTitle(value),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                          "Folder Color",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: DropdownButton<Color>(
                        value: _chosenColor,
                        items: [
                          for (final color in folderColors.entries)
                            DropdownMenuItem(
                              value: color.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: color.value,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(color.key),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _chosenColor = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Center(
                  child: widget.editedFolder == null
                      ? ElevatedButton.icon(
                          onPressed: _addFolder,
                          label: const Text('Add new folder'),
                          icon: const Icon(Icons.add),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _updateFolder(context),
                              label: const Text('Update folder'),
                              icon: const Icon(Icons.update),
                            ),
                            const SizedBox(width: 24),
                            ElevatedButton.icon(
                              onPressed: () => _showRemoveDialog(context),
                              label: const Text('Delete folder'),
                              icon: const Icon(Icons.delete),
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.red),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
