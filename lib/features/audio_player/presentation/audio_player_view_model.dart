import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rec_sesh/features/projects/domain/audio_track.dart';
import 'package:rec_sesh/features/audio_player/application/audio_player_service.dart';

class AudioPlayerViewModel {
  AudioPlayerViewModel({required AudioPlayerService audioPlayerService})
    : _audioPlayerService = audioPlayerService;

  final _log = Logger('$AudioPlayerViewModel');
  final AudioPlayerService _audioPlayerService;

  ValueListenable<AudioFile?> get currentTrack =>
      _audioPlayerService.currentTrack;
  ValueListenable<bool> get isPlaying => _audioPlayerService.isPlaying;
  ValueListenable<Duration> get currentPosition =>
      _audioPlayerService.currentPosition;
  ValueListenable<double> get progressPosition =>
      _audioPlayerService.progressPosition;

  void stopPlayer() {
    _log.warning('TODO: STOP PLAYER');
  }

  void playTrack(AudioFile audioTrack) {
    _audioPlayerService.playTrack(audioTrack);
  }

  void playPauseToggled() {
    _log.info('Button: Play/Pause');
    _audioPlayerService.playPauseToggled();
  }

  void skipSeconds() {
    _log.info('Button: Seek +10s');
    _audioPlayerService.skipSeconds();
  }
}
