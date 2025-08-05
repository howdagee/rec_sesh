import 'package:flutter/material.dart';
import 'package:rec_sesh/features/audio_player/application/audio_player_service.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/utils/extensions.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/features/audio_recorder/presentation/new_recording_page.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_service.dart';
import 'package:rec_sesh/features/projects/data/project_track_repository.dart';
import 'package:rec_sesh/features/projects/presentation/project_list/project_card.dart';
import 'package:rec_sesh/shared_widgets/buttons/rec_ink_well.dart';
import 'package:rec_sesh/shared_widgets/rec_list_tile.dart';
import 'package:rec_sesh/features/projects/presentation/project_list/project_list_view_model.dart';
import 'package:rec_sesh/shared_widgets/rec_page.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  final TextEditingController _newProjectNameController =
      TextEditingController();

  late final _homeViewModel = ProjectListViewModel(
    routerService: locator<RouterService>(),
    notificationService: locator<NotificationService>(),
    audioPlayerService: locator<AudioPlayerService>(),
    audioTrackRepo: locator<ProjectTrackRepository>(),
  );

  late final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _homeViewModel.init();
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
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;

    return RecPage(
      title: 'RecSesh'.hardCoded,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_box, color: RecColors.primary, size: 28),
          onPressed: _showCreateProjectBottomSheet,
          tooltip: 'Create New Project'.hardCoded,
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: RecColors.grey, size: 28),
          onPressed: _homeViewModel.goToSettingsView,
          tooltip: 'Settings'.hardCoded,
        ),
      ],

      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Unassigned Tracks'.hardCoded,
                      style: textStyles.titleMedium,
                    ),
                    RecInkWell(
                      onTap: _homeViewModel.goToUnassignedTracksScreen,
                      child: Icon(
                        Icons.chevron_right,
                        color: RecColors.grey,
                        size: Sizes.p34,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder(
                  valueListenable: _homeViewModel.recentRecordings,
                  builder: (context, unassignedTracks, child) {
                    final recentTracks =
                        unassignedTracks
                            .map(
                              (audioTrack) => RecListTile(
                                key: ValueKey(audioTrack),
                                onTap: () {},
                                title: audioTrack.name,
                                leadingIcon: Icons.mic,
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.play_circle_fill,
                                    color: RecColors.primary,
                                    size: 32,
                                  ),
                                  onPressed:
                                      () =>
                                          _homeViewModel.playTrack(audioTrack),
                                ),
                                subtitle: Text(
                                  audioTrack.createdAt,
                                  style: textStyles.xs.copyWith(
                                    color: RecColors.grey,
                                  ),
                                ),
                              ),
                            )
                            .toList();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [...recentTracks],
                    );
                  },
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
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: _homeViewModel.sampleProjects.length,
              (context, index) {
                final project = _homeViewModel.sampleProjects[index];
                return ProjectCard(
                  project: project,
                  onTap: () => _homeViewModel.goToProjectScreen(project),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Sizes.p40)),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _homeViewModel.isRecordButtonVisible,
        builder: (context, isVisible, child) {
          return Padding(
            padding: EdgeInsetsGeometry.only(
              bottom: Sizes.p24,
              right: Sizes.p16,
            ),
            child: AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: FloatingActionButton(
                onPressed: _openFullScreenRecordSheet,
                backgroundColor: RecColors.red,
                elevation: 6,
                child: const Icon(Icons.mic, color: RecColors.light, size: 32),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openFullScreenRecordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(child: const NewRecordingScreen());
      },
    );
  }

  void _showCreateProjectBottomSheet() {
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
                      onPressed: _newProjectNameController.clear,
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
}
