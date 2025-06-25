import 'package:flutter/material.dart';

class RecColors {
  const RecColors._();

  static const dark = Color(0xFF171717);
  static const surface = Color(0xFF1F1F1F);
  static const darkMedium = Color(0xFF1B1B1B);
  static const primary = Color(0xFF4ADE80);
  static const secondary = Color(0xFF61806E);
  static const light = Colors.white;
  static const grey = Color(0xFF878787);
  static const red = Color(0xFFE02D2D);
}

@immutable
class RecColorsExtension extends ThemeExtension<RecColorsExtension> {
  final Color dark;
  final Color surface;
  final Color darkMedium;
  final Color primary;
  final Color secondary;
  final Color light;
  final Color grey;
  final Color red;

  const RecColorsExtension({
    this.dark = RecColors.dark,
    this.surface = RecColors.surface,
    this.darkMedium = RecColors.darkMedium,
    this.primary = RecColors.primary,
    this.secondary = RecColors.secondary,
    this.light = RecColors.light,
    this.grey = RecColors.grey,
    this.red = RecColors.red,
  });

  @override
  ThemeExtension<RecColorsExtension> copyWith({
    Color? dark,
    Color? surface,
    Color? darkMedium,
    Color? primary,
    Color? secondary,
    Color? light,
    Color? grey,
    Color? red,
  }) {
    return RecColorsExtension(
      dark: dark ?? this.dark,
      surface: surface ?? this.surface,
      darkMedium: darkMedium ?? this.darkMedium,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      light: light ?? this.light,
      grey: grey ?? this.grey,
      red: red ?? this.red,
    );
  }

  @override
  ThemeExtension<RecColorsExtension> lerp(
    covariant ThemeExtension<RecColorsExtension>? other,
    double t,
  ) {
    if (other is! RecColorsExtension) {
      return this;
    }
    return RecColorsExtension(
      dark: Color.lerp(dark, other.dark, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      darkMedium: Color.lerp(darkMedium, other.darkMedium, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      light: Color.lerp(light, other.light, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      red: Color.lerp(red, other.red, t)!,
    );
  }
}
