import 'package:flutter/material.dart';
import 'package:rec_sesh/features/projects/domain/project.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/utils/extensions.dart';
import 'package:rec_sesh/core/utils/time_formatter.dart';
import 'package:rec_sesh/shared_widgets/rec_list_tile.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, required this.onTap});

  final Project project;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textStyles;
    final trackCount =
        project.trackCount == 1 ? '1 track' : '${project.trackCount} tracks';
    final lastEditTimeAgo = DateTimeFormatter.getTimeAgo(project.dateModified);

    return RecListTile(
      onTap: onTap,
      leadingIcon: Icons.folder_outlined,
      title: project.name,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(trackCount, style: textTheme.sm.copyWith(color: RecColors.grey)),
          Text(
            'Modified: $lastEditTimeAgo',
            style: textTheme.xs.copyWith(color: RecColors.grey),
          ),
        ],
      ),
      trailing: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 6),
        child: Icon(Icons.more_vert, color: RecColors.grey, size: 24),
      ),
    );
  }
}
