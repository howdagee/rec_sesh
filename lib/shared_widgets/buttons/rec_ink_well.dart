import 'package:flutter/material.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/sizes.dart';

class RecInkWell extends StatelessWidget {
  const RecInkWell({super.key, required this.onTap, required this.child});

  final GestureTapCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Sizes.p12),
      splashColor: RecColors.splashColor,
      onTap: onTap,
      child: child,
    );
  }
}
