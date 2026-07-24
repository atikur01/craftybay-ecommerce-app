import 'package:crafty_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class IncDecButton extends StatefulWidget {
  const IncDecButton({
    super.key,
    required this.maxCount,
    required this.minCount,
    required this.initialValue,
    required this.onChange,
  });

  final int maxCount;
  final int minCount;
  final int initialValue;
  final Function(int) onChange;

  @override
  State<IncDecButton> createState() => _IncDecButtonState();
}

class _IncDecButtonState extends State<IncDecButton> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        _iconButton(Icons.remove, () {
          if (_counter > widget.minCount) {
            _counter--;
            widget.onChange(_counter);
            setState(() {});
          }
        }, _counter <= widget.minCount),

        Text('$_counter', style: TextStyle(fontSize: 24)),
        _iconButton(Icons.add, () {
          if (_counter < widget.maxCount) {
            _counter++;
            widget.onChange(_counter);
            setState(() {});
          }
        }, _counter >= widget.maxCount),
      ],
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap, bool disable) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: .all(4),
        decoration: BoxDecoration(
          color: disable ? Colors.grey : AppColors.themeColor,
          borderRadius: .circular(4),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
