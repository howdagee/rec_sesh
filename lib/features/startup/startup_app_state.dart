sealed class StartupAppState {
  const StartupAppState();
}

class InitializingApp extends StartupAppState {
  const InitializingApp();
}

class AppInitialized extends StartupAppState {
  const AppInitialized();
}

class AppInitializationError extends StartupAppState {
  const AppInitializationError(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}
