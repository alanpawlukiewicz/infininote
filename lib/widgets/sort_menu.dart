import 'package:flutter/material.dart';

//ignore: must_be_immutable
class SortMenu extends StatefulWidget {
  const SortMenu({
    super.key,
    required this.onSortChange,
    required this.onLayoutChange,
  });

  final Function(String value, bool ascending) onSortChange;
  final Function() onLayoutChange;

  @override
  State<SortMenu> createState() => _SortMenuState();
}

class _SortMenuState extends State<SortMenu> {
  bool _ascending = false;
  String _val = 'modification_date';

  bool _isGridLayout = false;
  IconData _icon = Icons.list_alt;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
          onPressed: () {
            _isGridLayout = !_isGridLayout;
            if (_isGridLayout) {
              setState(() {
                _icon = Icons.grid_3x3;
              });
            } else {
              setState(() {
                _icon = Icons.list_alt;
              });
            }
            widget.onLayoutChange();
          },
          icon: Icon(_icon)),
      const Spacer(),
      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.sort),
            DropdownButton<String>(
              value: _val,
              items: [
                DropdownMenuItem(
                  value: 'title',
                  child: Text('Title'),
                ),
                DropdownMenuItem(
                  value: 'modification_date',
                  child: Text('Modification date'),
                ),
                DropdownMenuItem(
                  value: 'creation_date',
                  child: Text('Creation date'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _val = value!;
                });
                widget.onSortChange(_val, _ascending);
              },
            ),
            const VerticalDivider(
              endIndent: 10,
              indent: 10,
              color: Colors.grey,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _ascending = !_ascending;
                });
                widget.onSortChange(_val, _ascending);
              },
              icon:
                  Icon(_ascending ? Icons.arrow_upward : Icons.arrow_downward),
            ),
          ],
        ),
      ),
    ]);
  }
}
