import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:infininote/models/note.dart';
import 'package:infininote/notifications/notification_service.dart';
import 'package:infininote/widgets/notification_widgets/notification_textfield.dart';

class NotificationModalBottomSheet extends StatefulWidget {
  const NotificationModalBottomSheet({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<StatefulWidget> createState() => _NotificationModalBottomSheetState();
}

class _NotificationModalBottomSheetState
    extends State<NotificationModalBottomSheet> {
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  String? _errorText;

  String? _validateForm() {
    if (_hourController.text.isEmpty || _minuteController.text.isEmpty) {
      return 'Fields cannot be empty.';
    }
    if (int.tryParse(_hourController.text) == null ||
        int.tryParse(_minuteController.text) == null) {
      return 'Fields must containt numbers.';
    }

    final selectedHour = int.parse(
      _hourController.text,
    );
    final selectedMinute = int.parse(
      _minuteController.text,
    );

    if (selectedHour > 24 ||
        selectedHour < 0 ||
        selectedMinute > 59 ||
        selectedMinute < 0) {
      return 'Number out of scope.';
    }

    if (_selectedDate
            .add(Duration(hours: selectedHour, minutes: selectedMinute))
            .compareTo(DateTime.now()) ==
        -1) {
      return 'The reminder cannot be older than the current date.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _hourController.text = DateTime.now().hour.toString();
    DateTime.now().minute.toString().length == 1
        ? _minuteController.text = '0${DateTime.now().minute.toString()}'
        : _minuteController.text = DateTime.now().minute.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _hourController.dispose();
    _minuteController.dispose();
  }

  void _selectDate() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1);
    await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: lastDate,
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
        });
      }
    });
  }

  void _createNewNotification(BuildContext context) async {
    String? err = _validateForm();
    if (err != null) {
      setState(() {
        _errorText = err;
      });
      return;
    }

    final selectedHour = int.parse(
      _hourController.text,
    );
    final selectedMinute = int.parse(
      _minuteController.text,
    );

    DateTime scheduledDate = _selectedDate.add(
      Duration(
        hours: selectedHour,
        minutes: selectedMinute,
      ),
    );
    final bool isGranted = await NotificationService.scheduleNotification(
      widget.note.title,
      'Notification reminder.',
      scheduledDate,
    );
    if (context.mounted) {
      if (isGranted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Reminder has been scheduled.'),
          ),
        );
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Something went wrong.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            'Set a New Reminder',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                NotificationTextfield(
                  controller: _hourController,
                  helperText: 'Hour',
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 64,
                    ),
                  ),
                ),
                NotificationTextfield(
                  controller: _minuteController,
                  helperText: 'Minute',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _selectDate,
            label: const Text('Select date'),
            icon: const Icon(Icons.date_range),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat.yMMMd().format(_selectedDate),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _createNewNotification(context),
              icon: const Icon(Icons.alarm_add),
              label: const Text('Set reminder'),
            ),
          ),
          const SizedBox(height: 12),
          if (_errorText != null)
            Text(
              _errorText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
