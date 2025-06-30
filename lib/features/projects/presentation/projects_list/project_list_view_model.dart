import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rec_sesh/core/services/audio_player_service.dart';
import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_service.dart';
import 'package:rec_sesh/features/projects/domain/audio_track.dart';

/// Manages the dog image gallery for the home screen
class ProjectListViewModel {
  ProjectListViewModel({
    required RouterService routerService,
    required NotificationService notificationService,
    required AudioPlayerService audioPlayerService,
  }) : _routerService = routerService,
       _notificationService = notificationService,
       _audioPlayerService = audioPlayerService;

  final _logger = Logger('$ProjectListViewModel');
  final RouterService _routerService;
  final NotificationService _notificationService;
  final AudioPlayerService _audioPlayerService;

  // Notifiers
  final _isRecordButtonVisible = ValueNotifier(true);

  // Listeners
  ValueListenable<bool> get isRecordButtonVisible => _isRecordButtonVisible;

  final recentRecordings = [
    AudioTrack(
      id: 'id-1',
      name: 'Guitar Riff Idea',
      duration: const Duration(seconds: 45),
      dateCreated: DateTime.now(),
    ),
    AudioTrack(
      id: 'id-2',
      name: 'Acoustic Melody',
      duration: const Duration(minutes: 1, seconds: 23),
      dateCreated: DateTime.now(),
    ),
  ];
  final List<Map<String, dynamic>> projects = [
    {
      'name': 'Morning Jam Session',
      'tracks': 5,
      'details': 'Last Edited: 2 days ago',
    },
    {'name': 'Metal Demo', 'tracks': 3, 'details': 'Created: 1 week ago'},
    {
      'name': 'Acoustic Ballad Idea',
      'tracks': 1,
      'details': 'Last Edited: Yesterday',
    },
    {
      'name': 'Jazz Fusion Track',
      'tracks': 8,
      'details': 'Last Edited: 3 days ago',
    },
    {'name': 'Electronic Beat', 'tracks': 2, 'details': 'Created: 4 days ago'},
  ];

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

  void dispose() {}

  void viewAllUnassignedTracks() {
    _notificationService.show('TODO: create view for all unassigned tracks.');
  }

  void createProject(String projectName) {
    _notificationService.show('TODO: create project "$projectName"');
  }

  void goToProjectScreen() {
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

  void playTrack(AudioTrack recording) {
    _logger.info('Playing track ${recording.name}');
    _audioPlayerService.playTrack(recording);
  }
}
