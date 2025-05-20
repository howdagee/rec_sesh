import 'package:flutter/widgets.dart';
import 'package:rec_sesh/core/config/locator_config.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/startup/startup_app_state.dart';

class StartupViewModel {
  StartupViewModel();

  final appStateNotify = ValueNotifier<StartupAppState>(
    const InitializingApp(),
  );

  // TODO(JDJ): Add logging subscription

  Future<void> initializeApp() async {
    appStateNotify.value = const InitializingApp();
    try {
      locator.registerMany(modules);
      appStateNotify.value = const AppInitialized();
    } catch (e, stack) {
      appStateNotify.value = AppInitializationError(e, stack);
    }
  }

  Future<void> retryInitialization() async {
    locator.reset();
    await initializeApp();
  }

  void dispose() {
    appStateNotify.dispose();
  }
}
