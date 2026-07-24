import 'package:crafty_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class SizePicker extends StatefulWidget {
  const SizePicker({super.key, required this.sizes, required this.onChange});

  final List<String> sizes;
  final Function(String) onChange;

  @override
  State<SizePicker> createState() => _SizePickerState();
}

class _SizePickerState extends State<SizePicker> {
  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: widget.sizes.map((size) {
        return GestureDetector(
          onTap: () {
            _selectedSize = size;
            widget.onChange(size);
            setState(() {});
          },
          child: Container(
            padding: .symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              border: .all(color: Colors.grey),
              borderRadius: .circular(4),
              color: size == _selectedSize ? AppColors.themeColor : null,
            ),
            child: Text(
              size,
              style: TextStyle(
                fontSize: 16,
                color: size == _selectedSize ? Colors.white : null,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
