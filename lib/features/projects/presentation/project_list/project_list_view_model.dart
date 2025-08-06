import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rec_sesh/core/config/route_config.dart';
import 'package:rec_sesh/features/projects/domain/audio_track.dart';
import 'package:rec_sesh/features/projects/domain/project.dart';
import 'package:rec_sesh/features/audio_player/application/audio_player_service.dart';
import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_service.dart';
import 'package:rec_sesh/features/projects/data/project_track_repository.dart';

class ProjectListViewModel {
  ProjectListViewModel({
    required RouterService routerService,
    required NotificationService notificationService,
    required AudioPlayerService audioPlayerService,
    required ProjectTrackRepository audioTrackRepo,
  }) : _routerService = routerService,
       _notificationService = notificationService,
       _audioPlayerService = audioPlayerService,
       _projectsRepo = audioTrackRepo;

  final _logger = Logger('$ProjectListViewModel');
  final RouterService _routerService;
  final NotificationService _notificationService;
  final AudioPlayerService _audioPlayerService;
  final ProjectTrackRepository _projectsRepo;

  // Notifiers
  final _isRecordButtonVisible = ValueNotifier(true);

  // Listeners
  ValueListenable<List<Project>> get projects => _projectsRepo.projects;
  ValueListenable<bool> get isRecordButtonVisible => _isRecordButtonVisible;
  ValueListenable<List<AudioFile>> get unassignedTracks =>
      _projectsRepo.unassignedTracks;
  ValueListenable<List<AudioFile>> get recentRecordings =>
      _projectsRepo.recentRecordings;

  final List<Project> sampleProjects = [
    Project(
      name: 'Morning Jam Session',
      path: 'path',
      trackCount: 4,
      dateModified: DateTime.now().subtract(Duration(days: 2, seconds: 239)),
    ),
    Project(
      name: 'Metal Demo',
      path: 'path',
      trackCount: 4,
      dateModified: DateTime.now().subtract(Duration(days: 3, seconds: 99)),
    ),
    Project(
      name: 'Jazzy',
      path: 'path',
      trackCount: 2,
      dateModified: DateTime.now().subtract(Duration(days: 8, seconds: 454)),
    ),
    Project(
      name: 'Acoustic Session',
      path: 'path',
      trackCount: 2,
      dateModified: DateTime.now().subtract(Duration(days: 12, seconds: 232)),
    ),
    Project(
      name: 'Rock Demo',
      path: 'path',
      trackCount: 1,
      dateModified: DateTime.now().subtract(Duration(days: 13, seconds: 999)),
    ),
    Project(
      name: 'Lo-Fi demo',
      path: 'path',
      trackCount: 3,
      dateModified: DateTime.now().subtract(Duration(days: 13, seconds: 999)),
    ),
  ];

  Future<void> init() async {
    // await _projectsRepo.getProjectsList();
    await _projectsRepo.getRecentRecordings();
  }

  void goToSettingsView() {
    _routerService.goTo(RecPath(name: '/settings'));
  }

  void selectProjectOptions() {
    _notificationService.show('TODO: More options for projects');
  }

  void selectTrackOptions() {
    _notificationService.show('TODO: More options for tracks');
  }

  void selectQuickRecord() {
    _notificationService.show('TODO: quick record feature');
  }

  void createProject(String projectName) {
    _notificationService.show('TODO: create project "$projectName"');
  }

  void goToProjectScreen(Project project) {
    _notificationService.show('TODO: go to project details screen');
  }

  void showRecordButton() {
    if (_isRecordButtonVisible.value) {
      return;
    }
    _logger.info('Show record button...');
    _isRecordButtonVisible.value = true;
  }

  void hideRecordButton() {
    if (!_isRecordButtonVisible.value) {
      return;
    }
    _logger.info('Hiding record button...');
    _isRecordButtonVisible.value = false;
  }

  void playTrack(AudioFile recording) {
    _logger.info('Playing track ${recording.name}');
    _audioPlayerService.playTrack(recording);
  }

  Future<void> goToUnassignedTracksScreen() async {
    _routerService.goTo(RecPath(name: RecRoute.unassignedRecordings));
  }
}
