import 'package:flutter/material.dart';

class SettingDropdown extends StatelessWidget {
  const SettingDropdown({
    super.key,
    required this.title,
    required this.chosenValue,
    required this.itemArray,
    required this.onChanged,
    this.isTextStyle = false,
  });

  final String title;
  final String chosenValue;
  final Map<String, dynamic> itemArray;
  final Function(String value) onChanged;
  final bool isTextStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Spacer(),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: chosenValue,
            items: [
              for (final item in itemArray.entries)
                DropdownMenuItem(
                  value: item.key,
                  child: Text(
                    item.key,
                    style: isTextStyle
                        ? TextStyle(
                            fontFamily: item.value['Font'].fontFamily,
                          )
                        : null,
                  ),
                ),
            ],
            onChanged: (value) => onChanged(value!),
          ),
        ),
      ],
    );
  }
}
