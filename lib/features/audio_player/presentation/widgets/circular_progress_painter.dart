import 'dart:ui';

import 'package:flutter/widgets.dart' show CustomPainter;

class CircularProgressPainter extends CustomPainter {
  final double progress; // Value from 0.0 to 1.0
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background arc (inactive track)
    final paintInactive =
        Paint()
          ..color = inactiveColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
      -0.5 * 3.14159, // Start at top (-90 degrees)
      2 * 3.14159, // Sweep a full circle
      false,
      paintInactive,
    );

    // Foreground arc (active progress)
    final paintActive =
        Paint()
          ..color = activeColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
      -0.5 * 3.14159, // Start at top (-90 degrees)
      2 * 3.14159 * progress, // Sweep based on progress
      false,
      paintActive,
    );
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
