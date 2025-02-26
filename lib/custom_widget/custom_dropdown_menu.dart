// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items; // Pass dropdown items here
  final String hintText;
  final ValueChanged<String?> onChanged;
  final bool isExpanded;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.isExpanded,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      borderRadius: const BorderRadius.all(Radius.circular(7)),
      value: _selectedItem,
      hint: Text(
        widget.hintText,
        style: const TextStyle(
          color: Colors.indigo,
        ),
      ),
      isExpanded: widget.isExpanded,
      onChanged: (value) {
        setState(() {
          _selectedItem = value;
        });
        widget.onChanged(value);
      },
      items: widget.items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              // textDirection: TextDirection.rtl,
              item,
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
