import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/data/color_schemes.dart';
import 'package:infininote/data/fonts.dart';
import 'package:infininote/providers/folder_provider.dart';
import 'package:infininote/providers/note_provider.dart';
import 'package:infininote/providers/theme_provider.dart';
import 'package:infininote/widgets/setting_dropdown.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    String chosenFont = ref.read(themeProvider.notifier).textThemeName;
    String chosenColor = ref.read(themeProvider.notifier).colorSchemeName;
    String chosenTheme = ref.read(themeProvider.notifier).themeModeName;

    void removeData() async {
      await ref.read(noteProvider.notifier).truncateTable();
      await ref.read(folderProvider.notifier).truncateTable(ref);
    }

    Future<void> showRemoveDialog(BuildContext context) {
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
                  'Delete Data',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            content: const Text(
                'Are you sure you want to delete your data? You will permanently lose your notes and folders.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  removeData();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data has been removed.')),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                ),
                child: const Text('Delete Data'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SettingDropdown(
              title: 'Font family',
              chosenValue: chosenFont,
              itemArray: fonts,
              onChanged: (value) {
                setState(() {
                  chosenFont = value;
                  ref.read(themeProvider.notifier).setTextTheme(value);
                });
              },
              isTextStyle: true,
            ),
            SettingDropdown(
              title: 'Color scheme',
              chosenValue: chosenColor,
              itemArray: colorSchemes,
              onChanged: (value) {
                setState(() {
                  chosenColor = value;
                  ref.read(themeProvider.notifier).setColorScheme(value);
                });
              },
            ),
            SettingDropdown(
              title: 'Theme Mode',
              chosenValue: chosenTheme,
              itemArray: themeModes,
              onChanged: (value) {
                setState(() {
                  chosenTheme = value;
                  ref.read(themeProvider.notifier).setThemeMode(value);
                });
              },
            ),
            const SizedBox(height: 48.0),
            Container(
              alignment: Alignment.topRight,
              child: ElevatedButton.icon(
                onPressed: () => showRemoveDialog(context),
                label: const Text('Reset data'),
                icon: const Icon(Icons.delete_forever),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
