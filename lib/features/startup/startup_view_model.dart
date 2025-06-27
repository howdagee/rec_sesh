import 'dart:async';

import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:rec_sesh/core/services/logging_service.dart';
import 'package:rec_sesh/core/config/locator_config.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/features/startup/startup_app_state.dart';

class StartupViewModel {
  StartupViewModel({LoggingService? loggingService})
    : _loggingService = loggingService ?? LoggingService();

  final _logger = Logger('$StartupViewModel');
  final appStateNotify = ValueNotifier<StartupAppState>(
    const InitializingApp(),
  );

  final LoggingService _loggingService;
  late StreamSubscription<LogRecord> _loggingSubscription;

  Future<void> initializeApp() async {
    appStateNotify.value = const InitializingApp();
    try {
      locator.registerMany(modules);
      _loggingSubscription = _loggingService.init();
      appStateNotify.value = const AppInitialized();
    } catch (e, stack) {
      appStateNotify.value = AppInitializationError(e, stack);
    }

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      _logger.shout(
        'FlutterError ${details.exceptionAsString()}',
        details.stack,
      );
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      _logger.shout('[PlatformDispatcher] $error', error, stack);
      return true;
    };
  }

  Future<void> retryInitialization() async {
    locator.reset();
    await initializeApp();
  }

  void dispose() {
    appStateNotify.dispose();
    _loggingSubscription.cancel();
  }
}
