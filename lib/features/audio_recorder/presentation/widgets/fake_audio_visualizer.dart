// --- NEW: Fake Audio Visualizer Widget ---
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';

class FakeAudioVisualizer extends StatefulWidget {
  final bool isPaused;
  final double height; // The fixed height of the visualizer area
  final Color barColor; // Color of the bars

  const FakeAudioVisualizer({
    super.key,
    required this.isPaused,
    this.height = 100.0, // Default height, matching the previous placeholder
    this.barColor = RecColors.primary,
  });

  @override
  State<FakeAudioVisualizer> createState() => _FakeAudioVisualizerState();
}

class _FakeAudioVisualizerState extends State<FakeAudioVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // Using a fixed number of bars for simplicity in this fake visualizer
  final int numberOfBars = 40;
  final List<double> _barHeights = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Initialize bar heights to a minimum
    for (int i = 0; i < numberOfBars; i++) {
      _barHeights.add(widget.height * 0.1); // Start at 10% of max height
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ), // How quickly bar heights change
    )..addListener(() {
      if (!widget.isPaused) {
        // Update bar heights randomly on each animation tick
        setState(() {
          for (int i = 0; i < numberOfBars; i++) {
            // Ensure height is within a reasonable range (e.g., 10% to 90% of container height)
            _barHeights[i] =
                _random.nextDouble() * widget.height * 0.8 +
                widget.height * 0.1;
          }
        });
      }
    });

    // Start the animation loop if not initially paused
    if (!widget.isPaused) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant FakeAudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Control animation based on parent's isPaused state
    if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
        // Optionally reset bars to a minimum height when paused
        setState(() {
          for (int i = 0; i < numberOfBars; i++) {
            _barHeights[i] = widget.height * 0.1;
          }
        });
      } else {
        _controller.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // The painter is responsible for drawing the bars
      painter: _BarVisualizerPainter(
        barHeights: _barHeights,
        barColor: widget.barColor,
        maxHeight: widget.height,
      ),
      // Sized box ensures the CustomPaint has a defined size
      child: SizedBox(height: widget.height, width: double.infinity),
    );
  }
}

class _BarVisualizerPainter extends CustomPainter {
  final List<double> barHeights;
  final Color barColor;
  final double maxHeight;

  _BarVisualizerPainter({
    required this.barHeights,
    required this.barColor,
    required this.maxHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color =
              barColor // Set the color of the bars
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round; // Makes bars slightly rounded at top

    const double barWidth = 4.0; // Width of each individual bar
    // Calculate spacing between bars
    final double totalBarsWidth = barHeights.length * barWidth;
    final double totalSpacingWidth = size.width - totalBarsWidth;
    final double spacing =
        barHeights.length > 1 ? totalSpacingWidth / (barHeights.length - 1) : 0;
    // Ensure spacing is not negative if content is too wide
    final double actualSpacing =
        spacing.isFinite && spacing >= 0 ? spacing : barWidth / 2;

    for (int i = 0; i < barHeights.length; i++) {
      final double x = i * (barWidth + actualSpacing);
      final double height = barHeights[i];

      // Draw the rectangle (bar)
      // Bars are drawn from the bottom of the canvas, centered vertically within the available height
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, (size.height - height) / 2, barWidth, height),
          const Radius.circular(2.0), // Rounded corners for bars
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarVisualizerPainter oldDelegate) {
    // Only repaint if the bar heights or color change
    return oldDelegate.barHeights != barHeights ||
        oldDelegate.barColor != barColor;
  }
}
