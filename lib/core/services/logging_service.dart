import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class LoggingService {
  LoggingService();

  /// Subscribes to Logger and listens for new log entries. Prints out the
  /// content in debug mode.
  StreamSubscription<LogRecord> init() {
    Logger.root.level = Level.ALL;

    return Logger.root.onRecord.listen((record) {
      if (!kReleaseMode) {
        _printLog(record);
        return;
      }
    });
  }

  void _printLog(LogRecord record) {
    switch (record.level) {
      case Level.WARNING:
        debugPrint(
          '🟡 [${record.level.name}] <${record.loggerName}> ${record.message}',
        );
        break;
      case Level.SEVERE:
        debugPrint(
          '🔴 [${record.level.name}] <${record.loggerName}> ${record.message}',
        );
        break;
      case Level.SHOUT:
        debugPrint(
          '🔴 [${record.level.name}] <${record.loggerName}> ${record.message}',
        );
        break;
      default:
        debugPrint(
          '🟢 [${record.level.name}] <${record.loggerName}> ${record.message}',
        );
        break;
    }
  }
}
