import 'package:flutter/material.dart';
import 'package:infininote/data/folder_colors.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Folder {
  Folder({
    required this.name,
    this.color = Colors.grey,
  }) : id = uuid.v4();

  Folder.load({
    required this.name,
    required this.color,
    required this.id,
  });

  final String name;
  final String id;
  final Color color;
  

  String get colorKey {
    return folderColors.entries
        .where((element) => element.value == color)
        .toList()[0]
        .key;
  }
}
