import 'package:flutter/material.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/utils/extensions.dart';

class RecListTile extends StatelessWidget {
  const RecListTile({
    super.key,
    required this.onTap,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.onTapTrailing,
  });

  final String title;
  final Widget? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapTrailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        minVerticalPadding: 12,
        leading: Icon(leadingIcon, color: RecColors.secondary, size: Sizes.p24),
        trailing: trailing,
        title: Text(title, style: context.textStyles.titleSmall),
        subtitle: subtitle,
        splashColor: RecColors.secondary.withValues(alpha: .3),
        tileColor: RecColors.surface,
        onTap: onTap,
      ),
    );
  }
}
