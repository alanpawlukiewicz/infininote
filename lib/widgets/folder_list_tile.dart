import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/models/folder.dart';
import 'package:infininote/providers/folder_provider.dart';
import 'package:infininote/screens/add_folder.dart';

class FolderListTile extends ConsumerStatefulWidget {
  const FolderListTile({
    super.key,
    required this.folder,
  });

  final Folder folder;

  @override
  ConsumerState<FolderListTile> createState() => _FolderListTileState();
}

class _FolderListTileState extends ConsumerState<FolderListTile> {
  void _changeFolder(String folderId, WidgetRef ref, BuildContext context) {
    ref.read(folderIdProvider.notifier).setId(folderId);
    Navigator.of(context).pop();
  }

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
          value: "edit",
          child: Row(
            children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
          ),
        ),
        const PopupMenuItem(
          value: "close",
          child: Row(
            children: [Icon(Icons.close), SizedBox(width: 8), Text('Close')],
          ),
        ),
      ],
    );

    if (result == 'edit') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AddFolderScreen(
              editedFolder: widget.folder,
            );
          },
        ),
      );
    }
    if (result == 'close') {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        leading: Icon(
          ref.read(folderIdProvider) == widget.folder.id
              ? Icons.folder_open
              : Icons.folder,
          color: widget.folder.color,
        ),
        title: Text(
          widget.folder.name,
        ),
        onTap: () {
          _changeFolder(widget.folder.id, ref, context);
        },
        onLongPress: () => _showContextMenu(context),
      ),
      onTapDown: (position) => _getTapPosition(position),
    );
  }
}
