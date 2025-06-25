import 'package:flutter/material.dart';
import 'package:rec_sesh/core/theme/breakpoints.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/text_styles.dart';

extension TextThemeX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  CustomTextStyles get textStyles =>
      Theme.of(this).extension<CustomTextStyles>()!;

  RecColorsExtension get colors =>
      Theme.of(this).extension<RecColorsExtension>()!;

  CustomBreakpoints get breakpoints =>
      Theme.of(this).extension<CustomBreakpoints>()!;
}
