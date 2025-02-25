import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMMMd();

class Note {
  Note({
    required this.title,
    required this.contents,
    required this.folderId,
    DateTime? newCreationDate,
  })  : id = uuid.v4(),
        creationDate = newCreationDate ?? DateTime.now(),
        modificationDate = DateTime.now();

  const Note.load({
    required this.title,
    required this.contents,
    required this.id,
    required this.folderId,
    required this.creationDate,
    required this.modificationDate,
  });

  final String title;
  final List<dynamic> contents;
  final String id;
  final String folderId;
  final DateTime creationDate;
  final DateTime modificationDate;

  String get plainText {
    final c = QuillController(
      document: Document.fromJson(contents),
      selection: TextSelection.collapsed(offset: 0),
    );
    final decodedContent = c.document.getPlainText(0, c.document.length);
    c.dispose();
    return decodedContent;
  }

  String get encodedContents {
    return json.encode(contents);
  }

  String get formattedCreationDate {
    return formatter.format(creationDate);
  }

  String get formattedCreationDateTime {
    return creationDate.minute.toString().length == 1
        ? '${creationDate.hour}:0${creationDate.minute}, ${formatter.format(creationDate)}'
        : '${creationDate.hour}:${creationDate.minute}, ${formatter.format(creationDate)}';
  }

  String get formattedModificationDateTime {
    return modificationDate.minute.toString().length == 1
        ? '${modificationDate.hour}:0${modificationDate.minute}, ${formatter.format(modificationDate)}'
        : '${modificationDate.hour}:${modificationDate.minute}, ${formatter.format(modificationDate)}';
  }
}
