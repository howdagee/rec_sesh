import 'package:flutter/material.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';

@immutable
class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
  const CustomTextStyles({
    this.xs = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
    ),
    this.sm = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
    this.standard = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: RecColors.light,
    ),
    this.titleSmall = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: RecColors.light,
      letterSpacing: 0.25,
    ),
    this.titleMedium = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 18.0,
      fontWeight: FontWeight.w300,
      color: RecColors.light,
      letterSpacing: 0.25,
    ),
    this.titleLarge = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 21.0,
      fontWeight: FontWeight.w300,
      color: RecColors.light,
      letterSpacing: 0.25,
    ),
    this.headline = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 21.0,
      fontWeight: FontWeight.w600,
      color: RecColors.light,
    ),
  });

  /// 12
  final TextStyle xs;

  /// 14
  final TextStyle sm;

  /// 16
  final TextStyle standard;

  /// 16, medium
  final TextStyle titleSmall;

  /// 18, semi-bold
  final TextStyle titleMedium;

  /// 22
  final TextStyle titleLarge;

  /// 25, semi-bold
  final TextStyle headline;

  @override
  CustomTextStyles copyWith({
    TextStyle? xs,
    TextStyle? sm,
    TextStyle? standard,
    TextStyle? lg,
    TextStyle? xl,
    TextStyle? xxl,
    TextStyle? xxxl,
  }) {
    return CustomTextStyles(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      standard: standard ?? this.standard,
      titleSmall: lg ?? titleSmall,
      titleMedium: xl ?? titleMedium,
      titleLarge: xxl ?? titleLarge,
      headline: xxxl ?? headline,
    );
  }

  @override
  CustomTextStyles lerp(ThemeExtension<CustomTextStyles>? other, double t) {
    if (other is! CustomTextStyles) return this;
    return CustomTextStyles(
      // TextStyle.lerp handles interpolating all properties, including weight
      xs: TextStyle.lerp(xs, other.xs, t)!,
      sm: TextStyle.lerp(sm, other.sm, t)!,
      standard: TextStyle.lerp(standard, other.standard, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
    );
  }
}
