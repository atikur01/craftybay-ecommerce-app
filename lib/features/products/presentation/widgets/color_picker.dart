import 'package:crafty_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key, required this.colors, required this.onChange});

  final List<String> colors;
  final Function(String) onChange;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: widget.colors.map((color) {
        return GestureDetector(
          onTap: () {
            _selectedColor = color;
            widget.onChange(color);
            setState(() {});
          },
          child: Container(
            padding: .symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              border: .all(color: Colors.grey),
              borderRadius: .circular(4),
              color: color == _selectedColor ? AppColors.themeColor : null,
            ),
            child: Text(
              color,
              style: TextStyle(
                fontSize: 16,
                color: color == _selectedColor ? Colors.white : null,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
