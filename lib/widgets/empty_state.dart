import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_folder.png',
          ),
          Text(
            'No notes yet',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 24.0,
                ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "Tap the '+' icon to get started",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
