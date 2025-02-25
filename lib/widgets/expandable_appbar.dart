import 'package:flutter/material.dart';
import 'package:infininote/models/note.dart';

class ExpandableAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ExpandableAppBar({
    super.key,
    required this.note,
    required this.onDismiss,
    required this.titleController,
  });

  final Note note;
  final Function() onDismiss;
  final TextEditingController titleController;

  @override
  State<ExpandableAppBar> createState() => _ExpandableAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(200.0);
}

class _ExpandableAppBarState extends State<ExpandableAppBar> {
  bool _isExpanded = false;
  double _height = 102.0;

  void _toggleAppBar() {
    setState(() {
      _isExpanded = !_isExpanded;
      _height = _isExpanded ? 150.0 : 102.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _height,
      child: AppBar(
        toolbarHeight: _height,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isExpanded
              ? Column(
                  key: const ValueKey(1),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      cursorColor: Colors.black26,
                      controller: widget.titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        helperText: 'Change title',
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                )
              : Text(widget.note.title, key: ValueKey(2)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onDismiss,
        ),
        actions: [
          IconButton(
            icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: _toggleAppBar,
          ),
        ],
      ),
    );
  }
}
