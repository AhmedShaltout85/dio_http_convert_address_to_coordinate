
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final bool isExpanded;
  final String? value; // Add this to control the selected value from parent

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.isExpanded,
    this.value, // Add this parameter
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      alignment: AlignmentDirectional.center,
      borderRadius: const BorderRadius.all(Radius.circular(7)),
      value: widget.value, // Use the value from parent instead of local state
      hint: Text(
        widget.hintText,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          color: Colors.indigo,
        ),
      ),
      isExpanded: widget.isExpanded,
      onChanged: (value) {
        // Remove local state management and just notify parent
        widget.onChanged(value);
      },
      items: widget.items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          alignment: Alignment.center,
          value: item,
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
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
