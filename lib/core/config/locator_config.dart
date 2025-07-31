import 'package:rec_sesh/core/services/audio_player_service.dart';
import 'package:rec_sesh/core/services/logging_service.dart';
import 'package:rec_sesh/core/config/routes.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/features/projects/data/file_system_data_source.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_service.dart';

//? TODO: Create other module lists for different flavors of the app?

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
];
