import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    super.key,
    required this.data,
    required this.animation,
    required this.index,
    required this.onDelete,
  });

  final PendingNotificationRequest data;
  final Animation<double> animation;
  final int index;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      key: ValueKey(data.id),
      child: ListTile(
        title: Text(data.title!),
        subtitle: Text(data.payload!),
        leading: Icon(
          Icons.notifications,
        ),
        trailing: CircleAvatar(
          backgroundColor: Colors.red,
          child: IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
