import 'package:flutter/material.dart';

class CenteredProcessIndicator extends StatelessWidget {
  const CenteredProcessIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
