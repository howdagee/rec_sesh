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
    this.onLongPress,
    this.selected = false,
  });

  final String title;
  final Widget? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapTrailing;
  final GestureTapCallback? onLongPress;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        selectedTileColor: RecColors.splashColor,
        minVerticalPadding: 12,
        selected: selected,
        leading: Icon(leadingIcon, color: RecColors.secondary, size: Sizes.p24),
        trailing: InkWell(onTap: onTapTrailing, child: trailing),
        title: Text(title, style: context.textStyles.titleSmall),
        subtitle: subtitle,
        splashColor: !selected ? RecColors.splashColor : Colors.transparent,
        tileColor: RecColors.surface,
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
