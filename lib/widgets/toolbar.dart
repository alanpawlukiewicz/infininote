import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key, required this.controller});

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return QuillSimpleToolbar(
      configurations: QuillSimpleToolbarConfigurations(
        multiRowsDisplay: false,
        embedButtons: FlutterQuillEmbeds.toolbarButtons(),
        color: Colors.transparent,
      ),
      controller: controller,
    );
  }
}
