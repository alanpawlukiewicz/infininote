import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class Editor extends StatelessWidget {
  const Editor({
    super.key,
    required this.controller,
  });

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: QuillEditor.basic(
          controller: controller,
          configurations: QuillEditorConfigurations(
            placeholder: 'Type here...',
            embedBuilders: kIsWeb
                ? FlutterQuillEmbeds.editorWebBuilders()
                : FlutterQuillEmbeds.editorBuilders(),
            contextMenuBuilder: (context, editableTextState) {
              return AdaptiveTextSelectionToolbar(
                anchors: editableTextState.contextMenuAnchors,
                children: [
                  ...editableTextState.contextMenuButtonItems.map(
                    (ContextMenuButtonItem buttonItem) {
                      return TextSelectionToolbarTextButton(
                        padding: const EdgeInsets.all(8),
                        onPressed: buttonItem.onPressed,
                        child: Text(
                          CupertinoTextSelectionToolbarButton.getButtonLabel(
                              context, buttonItem),
                        ),
                      );
                    },
                  ),
                  TextSelectionToolbarTextButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: () {
                      editableTextState.hideToolbar();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
