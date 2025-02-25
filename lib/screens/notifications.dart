import 'package:flutter/material.dart';
import 'package:infininote/notifications/notification_service.dart';
import 'package:infininote/widgets/notification_widgets/notification_empty_state.dart';
import 'package:infininote/widgets/notification_widgets/notification_list_tile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _listKey = GlobalKey<AnimatedListState>();
  late int _itemCount;

  void _removeAllNotifications() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Delete Notifications',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          content: const Text(
              'Are you sure you want to delete all impending notifications?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationService.flutterLocalNotificationPlugin.cancelAll();
                _listKey.currentState!.removeAllItems(
                  (context, animation) => SizeTransition(
                    sizeFactor: animation,
                  ),
                );
                Navigator.of(context).pop();
                setState(() {});
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              child: const Text('Delete notifications'),
            ),
          ],
        );
      },
    );
  }

  void _rn(int id) async {
    await NotificationService.flutterLocalNotificationPlugin.cancel(id);
  }

  void _removeNotification(int index, data) async {
    _listKey.currentState!.removeItem(
      index,
      (context, animation) {
        _rn(data.id);
        return SizeTransition(
          sizeFactor: animation,
          child: NotificationListTile(
              data: data, animation: animation, index: index, onDelete: () {}),
        );
      },
      duration: const Duration(milliseconds: 300),
    );
    _itemCount--;
    if (_itemCount == 0) {
      Future.delayed(const Duration(milliseconds: 350), () {
        setState(() {}); // Odtworzenie UI, jeśli lista stała się pusta
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NotificationService.flutterLocalNotificationPlugin
          .pendingNotificationRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          Widget currentWidget = const NotificationEmptyState();
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            _itemCount = snapshot.data!.length;
            currentWidget = Column(
              children: [
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: _itemCount,
                    itemBuilder: (context, index, animation) =>
                        NotificationListTile(
                      data: snapshot.data![index],
                      animation: animation,
                      index: index,
                      onDelete: () =>
                          _removeNotification(index, snapshot.data![index]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ElevatedButton.icon(
                    onPressed: _removeAllNotifications,
                    label: const Text('Remove all notifications.'),
                    icon: Icon(Icons.delete_forever),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                  ),
                ),
              ],
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Pending Notifications'),
            ),
            body: currentWidget,
          );
        }
      },
    );
  }
}
