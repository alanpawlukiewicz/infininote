import 'package:flutter/material.dart';

class NotificationTextfield extends StatelessWidget {
  const NotificationTextfield({
    super.key,
    required this.controller,
    required this.helperText,
  });

  final TextEditingController controller;
  final String helperText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 64,
            ),
          ),
          Text(
            helperText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
