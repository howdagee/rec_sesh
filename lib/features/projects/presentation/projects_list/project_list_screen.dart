import 'package:flutter/material.dart';
import 'package:rec_sesh/core/services/audio_player_service.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/utils/extensions.dart';
import 'package:rec_sesh/core/utils/helpers.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/core/utils/time_formatter.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_service.dart';
import 'package:rec_sesh/core/widgets/rec_list_tile.dart';
import 'package:rec_sesh/features/projects/presentation/projects_list/project_list_view_model.dart';
import 'package:rec_sesh/core/widgets/view_container.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final TextEditingController _newProjectNameController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late final _homeViewModel = ProjectListViewModel(
    routerService: locator<RouterService>(),
    notificationService: locator<NotificationService>(),
    audioPlayerService: locator<AudioPlayerService>(),
  );

  late final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      _homeViewModel.hideRecordButton();
    } else {
      _homeViewModel.showRecordButton();
    }
  }

  @override
  void dispose() {
    _newProjectNameController.dispose();
    _searchController.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;

    return ContentContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text('RecSesh'.hardCoded, style: textStyles.headline),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add_box,
                color: RecColors.primary,
                size: 28,
              ),
              onPressed: () {
                _showCreateProjectBottomSheet(context);
              },
              tooltip: 'Create New Project'.hardCoded,
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: RecColors.grey, size: 28),
              onPressed: _homeViewModel.goToSettingsView,
              tooltip: 'Settings'.hardCoded,
            ),
          ],
        ),
        body: ContentContainer(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.all(Sizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Unassigned Tracks'.hardCoded,
                            style: textStyles.titleMedium,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(Sizes.p12),
                            onTap: () {},
                            child: Icon(
                              Icons.chevron_right,
                              color: RecColors.grey,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (_homeViewModel.recentRecordings.isNotEmpty)
                      ..._homeViewModel.recentRecordings.map(
                        (recording) => RecListTile(
                          key: ValueKey(recording.id),
                          onTap: () {},
                          title: recording.name,
                          leadingIcon: Icons.mic,
                          trailing: IconButton(
                            icon: Icon(
                              Icons.play_circle_fill,
                              color: RecColors.primary,
                              size: 32,
                            ),
                            onPressed:
                                () => _homeViewModel.playTrack(recording),
                          ),
                          subtitle: Text(
                            '${DateTimeFormatter.getMonthDay(recording.dateCreated)} • ${formatDuration(recording.duration)}',
                            style: textStyles.xs.copyWith(
                              color: RecColors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Text(
                            'No unassigned tracks yet!'.hardCoded,
                            style: textStyles.titleMedium,
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Your Projects'.hardCoded,
                        style: textStyles.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (_homeViewModel.projects.isNotEmpty)
                      ..._homeViewModel.projects.map(
                        (project) => _buildProjectCard(
                          project['name']!,
                          project['tracks']!,
                          project['details']!,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Text(
                            'No projects created yet!'.hardCoded,
                            style: textStyles.titleSmall,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _homeViewModel.isRecordButtonVisible,
          builder: (context, isVisible, child) {
            return AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: FloatingActionButton(
                onPressed: _homeViewModel.selectQuickRecord,
                backgroundColor: RecColors.red,
                elevation: 6,
                child: const Icon(Icons.mic, color: RecColors.light, size: 32),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCreateProjectBottomSheet(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: RecColors.grey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Create New Project'.hardCoded,
                  style: textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _newProjectNameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter project name'.hardCoded,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: RecColors.secondary),
                      onPressed: () {
                        _newProjectNameController.clear();
                      },
                    ),
                  ),
                  style: textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final newName = _newProjectNameController.text;
                      if (newName.isNotEmpty) {
                        _createNewProject(context, newName);
                      } else {
                        // TODO(JDJ): Show error message around the form input
                      }
                    },
                    child: Text('Create Project'.hardCoded),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _newProjectNameController.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel'.hardCoded,
                      style: TextStyle(color: RecColors.light),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _createNewProject(BuildContext context, String projectName) {
    _homeViewModel.createProject(projectName);
    _newProjectNameController.clear();
    Navigator.pop(context);
  }

  Widget _buildProjectCard(String name, int count, String details) {
    final textTheme = context.textStyles;

    return RecListTile(
      onTap: _homeViewModel.goToProjectScreen,
      onTapTrailing: _homeViewModel.selectProjectOptions,
      leadingIcon: Icons.folder_outlined,
      title: name,
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count Tracks'.hardCoded,
            style: textTheme.sm.copyWith(color: RecColors.grey),
          ),
          const SizedBox(height: 2),
          Text(details, style: textTheme.xs.copyWith(color: RecColors.grey)),
        ],
      ),
      trailing: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 6),
        child: Icon(Icons.more_vert, color: RecColors.grey, size: 24),
      ),
    );
  }
}
