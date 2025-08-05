import 'package:rec_sesh/features/audio_player/application/audio_player_service.dart';
import 'package:rec_sesh/core/services/logging_service.dart';
import 'package:rec_sesh/core/config/route_config.dart';
import 'package:rec_sesh/features/audio_recorder/application/recorder_service.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/features/projects/data/file_system_data_source.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_service.dart';
import 'package:rec_sesh/features/projects/data/project_track_repository.dart';

/// List of modules that are registered in the StartupViewModel with
/// `locator.registerMany(modules)`
///
/// You can retrieve a module instance with:
/// ```dart
/// locator<RouterService>();
/// ```
final modules = [
  Module<LoggingService>(builder: () => LoggingService(), lazy: false),
  Module<RouterService>(
    builder: () => RouterService(supportedRoutes: routes),
    lazy: false,
  ),
  Module<NotificationService>(builder: () => NotificationService(), lazy: true),
  Module<FileSystemDataSource>(
    builder: () => FileSystemDataSource(),
    lazy: false,
  ),
  Module<AudioPlayerService>(builder: () => AudioPlayerService(), lazy: false),
  Module<ProjectTrackRepository>(
    builder:
        () => ProjectTrackRepository(
          projectTrackDataSource: locator<FileSystemDataSource>(),
        ),
    lazy: false,
  ),
  Module<RecorderService>(
    builder:
        () => RecorderService(
          projectTrackRepo: locator<ProjectTrackRepository>(),
        ),
    lazy: false,
  ),
];
