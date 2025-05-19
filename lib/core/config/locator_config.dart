import 'package:rec_sesh/core/config/routes.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/core/utils/toast/toast_service.dart';

//? TODO: Create other module lists for different flavors of the app?

/// List of modules that are registered in the StartupViewModel with
/// `locator.registerMany(modules)`
///
/// You can retrieve a module instance with:
/// ```dart
/// locator<RouterService>();
/// ```
final modules = [
  Module<RouterService>(
    builder: () => RouterService(supportedRoutes: routes),
    lazy: false,
  ),
  // TODO(JDJ): Add a LoggingService Module.
];
