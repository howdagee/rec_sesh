import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rec_sesh/features/audio_recorder/application/recorder_service.dart';
import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';

class NewRecordingViewModel {
  NewRecordingViewModel({
    required RouterService routerService,
    required RecorderService recorderService,
  }) : _routerService = routerService,
       _recorderService = recorderService;

  final _isRecording = ValueNotifier(true);
  final _isPaused = ValueNotifier(false);
  final _recordingDuration = ValueNotifier(Duration.zero);
  late Timer _timer;
  final _log = Logger('$NewRecordingViewModel');

  final RecorderService _recorderService;
  final RouterService _routerService;

  ValueListenable<bool> get isRecording => _isRecording;
  ValueListenable<bool> get isPaused => _isPaused;
  ValueListenable<Duration> get recordingDuration => _recordingDuration;

  void init() {
    _startRecording();
  }

  void dispose() {
    _timer.cancel();
    _recorderService.dispose();
  }

  void _startRecording() {
    _recorderService.startRecording();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused.value) {
        _recordingDuration.value += const Duration(seconds: 1);
      }
    });
  }

  void toggleRecordPause() {
    _isPaused.value = !_isPaused.value;
    _isRecording.value = !_isPaused.value;
    if (_isPaused.value) {
      _recorderService.pauseRecording();
      _log.info('Recording Paused');
    } else {
      _recorderService.continueRecording();
      _log.info('Recording Resumed');
    }
  }

  /// Discards the current recording and allows the user to press 'Record' to
  /// start a new one.
  void restartRecording() {
    // TODO(JDJ): Would be nice to not have to navigate away if a user wishes
    //  to start the recording over.
  }

  void saveRecording() {
    _recorderService.saveRecording();
    _timer.cancel();
    _log.info(
      'Recording Saved for ${_recordingDuration.value.inSeconds} seconds',
    );
  }

  void deleteRecording() {
    _recorderService.cancelRecording();
    _timer.cancel();
    _log.info('Recording Deleted');
    _routerService.backUntil(RecPath(name: '/'));
  }
}
