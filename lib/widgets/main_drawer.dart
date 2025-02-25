import 'package:flutter/material.dart';
import 'package:infininote/models/folder.dart';
import 'package:infininote/screens/add_folder.dart';
import 'package:infininote/screens/notifications.dart';
import 'package:infininote/screens/settings.dart';
import 'package:infininote/widgets/folder_list_tile.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.folders,
  });

  final List<Folder> folders;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/folder.png').image,
                alignment: Alignment.bottomLeft,
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 4.0),
                Text(
                  "Folders",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: folders.length,
              itemBuilder: (ctx, index) {
                return FolderListTile(folder: folders[index]);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add new Folder"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AddFolderScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text("Check Notifications"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
