import 'package:flutter/material.dart';

class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    this.maxWidth = 1080,
    required this.child,
  });

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
