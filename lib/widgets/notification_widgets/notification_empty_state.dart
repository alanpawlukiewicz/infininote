import 'package:flutter/material.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/add_notification.png',
          ),
          Text(
            'No notifications scheduled',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 24.0,
                ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "Hold your finger on the note, then click 'Set Reminder' to get started",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
