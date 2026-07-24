import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.headerText,
    required this.onTapSeeAll,
  });

  final String headerText;
  final VoidCallback onTapSeeAll;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(headerText, style: textTheme.titleMedium),
        TextButton(
          onPressed: onTapSeeAll,
          child: Text('See All', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
