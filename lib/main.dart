import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:rec_sesh/core/utils/navigation/url_strategy/url_strategy_stub.dart';
import 'package:rec_sesh/startup/startup_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // TODO(JDJ): Create a logging service/module to handle errors.
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // TODO(JDJ): Create a logging service/module to handle errors.
    debugPrint('PlatformDispatcher: $error\n$stack');
    return true;
  };

  runApp(const StartupView());
}
