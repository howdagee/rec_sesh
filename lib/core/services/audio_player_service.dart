import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rec_sesh/features/projects/domain/audio_track.dart';

class AudioPlayerService {
  final _log = Logger('$AudioPlayerService');

  // TODO(JDJ): Could probably group these together into an AudioPlayerState
  //  object.
  final _isPlayerVisible = ValueNotifier(true);
  final _currentTrackNotifier = ValueNotifier<AudioTrack?>(null);
  final _isPlaying = ValueNotifier<bool>(false);
  final _currentPosition = ValueNotifier<Duration>(Duration.zero);
  final _progressPosition = ValueNotifier<double>(0.0);

  Timer? _playbackTimer;

  ValueListenable<bool> get isPlayerVisible => _isPlayerVisible;
  ValueListenable<AudioTrack?> get currentTrack => _currentTrackNotifier;
  ValueListenable<bool> get isPlaying => _isPlaying;
  ValueListenable<Duration> get currentPosition => _currentPosition;
  ValueListenable<double> get progressPosition => _progressPosition;

  void playTrack(AudioTrack audioTrack) {
    _log.info('Playing track');
    _currentPosition.value = Duration.zero;
    _currentTrackNotifier.value = audioTrack;
    _startPlaybackSimulation();
  }

  void playPauseToggled() {
    if (_isPlaying.value) {
      _log.info('|| Pausing track "${_currentTrackNotifier.value?.name}.');
      _stopPlaybackSimulation();
    } else {
      _log.info('|> Resuming track "${_currentTrackNotifier.value?.name}.');
      if (_currentPosition.value >= _currentTrackNotifier.value!.duration) {
        _currentPosition.value = Duration.zero;
      }
      _startPlaybackSimulation();
    }
  }

  void skipSeconds() {
    _log.info('Skipping 10s');
    final totalDuration = _currentTrackNotifier.value!.duration;
    var newPosition = _currentPosition.value + const Duration(seconds: 10);
    if (newPosition >= totalDuration) {
      newPosition = totalDuration;
    }

    _currentPosition.value = newPosition;

    _calculateProgressBar();
  }

  void _calculateProgressBar() {
    final totalDuration =
        _currentTrackNotifier.value?.duration ?? Duration.zero;
    _progressPosition.value =
        totalDuration.inSeconds > 0
            ? _currentPosition.value.inSeconds.toDouble() /
                totalDuration.inSeconds.toDouble()
            : 0.0;
  }

  void _startPlaybackSimulation() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final totalDuration =
          _currentTrackNotifier.value?.duration ?? Duration.zero;
      // Update more frequently for smoother progress
      if (_currentPosition.value < totalDuration) {
        _currentPosition.value += const Duration(milliseconds: 500);
        if (_currentPosition.value > totalDuration) {
          // Cap at total duration
          _currentPosition.value = totalDuration;
        }
      } else {
        _stopPlaybackSimulation();
      }
      _calculateProgressBar();
    });
    _isPlaying.value = true;
  }

  void _stopPlaybackSimulation() {
    _playbackTimer?.cancel();
    _playbackTimer = null;

    _isPlaying.value = false;
  }
}
