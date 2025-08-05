import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rec_sesh/features/projects/data/project_track_repository.dart';
import 'package:record/record.dart';

class RecorderService {
  RecorderService({required ProjectTrackRepository projectTrackRepo})
    : _projectTrackRepo = projectTrackRepo;

  final _log = Logger('$RecorderService');
  final ProjectTrackRepository _projectTrackRepo;
  final _record = AudioRecorder();

  Future<void> startRecording() async {
    if (await _record.hasPermission()) {
      await _record.start(
        RecordConfig(encoder: AudioEncoder.wav),
        path: await _projectTrackRepo.getPathForNewRecording(),
      );
    }
  }

  Future<void> pauseRecording() async {
    await _record.pause();
  }

  Future<void> saveRecording() async {
    final path = await _record.stop();
    _log.info('Recording saved to: $path');
    _projectTrackRepo.getUnassignedRecordings();
  }

  Future<void> cancelRecording() async {
    _log.info('Recording cancelled');
    return _record.cancel();
  }

  Future<void> dispose() async {
    return _record.dispose();
  }

  Future<void> continueRecording() async {
    if (await _record.isPaused()) {
      await _record.resume();
    }
  }
}
