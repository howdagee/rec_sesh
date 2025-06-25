import 'package:flutter/material.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart' show RecColors;
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/theme/breakpoints.dart';
import 'package:rec_sesh/core/theme/text_styles.dart';

class RecTheme {
  static ThemeData buildTheme(Brightness brightness) {
    // final isDark = brightness == Brightness.dark;
    final textStyles = CustomTextStyles();
    final breakpoints = CustomBreakpoints();

    return ThemeData().copyWith(
      extensions: [textStyles, breakpoints],
      scaffoldBackgroundColor: RecColors.dark,
      appBarTheme: const AppBarTheme(color: RecColors.dark, elevation: 0),
      cardTheme: CardThemeData(
        color: RecColors.surface,
        elevation: Sizes.p4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.p12),
        ),
        margin: const EdgeInsets.symmetric(vertical: Sizes.p8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p10),
          ),
          elevation: Sizes.p4,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p20,
            vertical: Sizes.p16,
          ),
          backgroundColor: RecColors.primary,
          foregroundColor: RecColors.surface,
          textStyle: textStyles.titleSmall,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: RecColors.primary,
          textStyle: textStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: RecColors.primary,
        selectionColor: RecColors.primary.withValues(alpha: 0.3),
        selectionHandleColor: RecColors.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RecColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.p20,
          vertical: Sizes.p16,
        ),
        hintStyle: textStyles.sm.copyWith(color: RecColors.grey),
        labelStyle: TextStyle(
          color: RecColors.light,
          fontWeight: FontWeight.w400,
        ),
        prefixIconColor: RecColors.grey,
        suffixIconColor: RecColors.grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.p12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.p12),
          borderSide: BorderSide(color: RecColors.primary, width: Sizes.p2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.p12),
          borderSide: BorderSide.none,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: RecColors.primary,
        secondary: RecColors.secondary,
        surface: RecColors.surface,
        surfaceTint: Color(0xFF000000),
        onPrimary: RecColors.light,
        onSecondary: RecColors.light,
        onSurface: RecColors.light,
        error: RecColors.red,
        onError: RecColors.light,
      ),
      textTheme: TextTheme(
        headlineLarge: textStyles.headline,
        headlineMedium: textStyles.headline,
        headlineSmall: textStyles.headline,
        titleLarge: textStyles.titleLarge,
        titleMedium: textStyles.titleMedium,
        titleSmall: textStyles.titleSmall,
        bodyLarge: textStyles.standard,
        bodyMedium: textStyles.sm,
        bodySmall: textStyles.xs,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: RecColors.secondary,
        contentTextStyle: TextStyle(color: RecColors.light),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.p8),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: Sizes.p4,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: RecColors.dark,
        modalBarrierColor: Colors.black.withValues(alpha: 0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.p20)),
        ),
        elevation: Sizes.p10,
      ),
    );
  }
}
