import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:infininote/data/color_schemes.dart';
import 'package:infininote/data/fonts.dart';

final themeModes = {
  'System': ThemeMode.system,
  'Light': ThemeMode.light,
  'Dark': ThemeMode.dark,
};

final defaultTextTheme = fonts['Default']!['Text Theme'];
final defaultColorScheme = colorSchemes['Default']!;

class ThemeProvider extends StateNotifier<Map<String, dynamic>> {
  ThemeProvider()
      : super({
          'Theme Mode': ThemeMode.system,
          'Text Theme': defaultTextTheme,
          'Color Scheme': defaultColorScheme,
        });

  String get textThemeName {
    return fonts.entries
        .firstWhere(
            (element) => element.value['Text Theme'] == state['Text Theme'])
        .key;
  }

  String get colorSchemeName {
    return colorSchemes.entries
        .firstWhere((element) => element.value == state['Color Scheme'])
        .key;
  }

  String get themeModeName {
    return themeModes.entries
        .firstWhere((element) => element.value == state['Theme Mode'])
        .key;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/theme.json');
  }

  Future<void> setThemeMode(String newThemeModeName) async {
    state = {
      'Theme Mode': themeModes[newThemeModeName],
      'Text Theme': state['Text Theme'],
      'Color Scheme': state['Color Scheme'],
    };
    final file = await _localFile;

    final Map<String, dynamic> themeData = {
      'Theme Mode': newThemeModeName,
      'Text Theme': textThemeName,
      'Color Scheme': colorSchemeName,
    };

    await file.writeAsString(jsonEncode(themeData));
  }

  Future<void> setTextTheme(String newTextThemeName) async {
    state = {
      'Theme Mode': state['Theme Mode'],
      'Text Theme': fonts[newTextThemeName]!['Text Theme'],
      'Color Scheme': state['Color Scheme'],
    };
    final file = await _localFile;

    final Map<String, dynamic> themeData = {
      'Theme Mode': themeModeName,
      'Text Theme': newTextThemeName,
      'Color Scheme': colorSchemeName,
    };

    await file.writeAsString(jsonEncode(themeData));
  }

  Future<void> setColorScheme(String newColorSchemeName) async {
    state = {
      'Theme Mode': state['Theme Mode'],
      'Text Theme': state['Text Theme'],
      'Color Scheme': colorSchemes[newColorSchemeName],
    };
    final file = await _localFile;

    final Map<String, dynamic> themeData = {
      'Theme Mode': themeModeName,
      'Text Theme': textThemeName,
      'Color Scheme': newColorSchemeName,
    };

    await file.writeAsString(jsonEncode(themeData));
  }

  Future<void> loadTheme() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();

      final Map<String, dynamic> themeData = jsonDecode(contents);

      ThemeMode themeMode = themeModes[themeData['Theme Mode']]!;
      TextTheme textTheme = fonts[themeData['Text Theme']]!['Text Theme'];
      ColorScheme colorScheme = colorSchemes[themeData['Color Scheme']]!;

      state = {
        'Theme Mode': themeMode,
        'Text Theme': textTheme,
        'Color Scheme': colorScheme,
      };
    } catch (e) {
      state = {
        'Theme Mode': ThemeMode.system,
        'Text Theme': defaultTextTheme,
        'Color Scheme': defaultColorScheme,
      };
    }
  }
}

final themeProvider =
    StateNotifierProvider<ThemeProvider, Map<String, dynamic>>((ref) {
  return ThemeProvider();
});
