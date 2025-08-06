import 'package:flutter/foundation.dart';
import 'package:rec_sesh/features/projects/domain/audio_track.dart';
import 'package:rec_sesh/features/audio_player/application/audio_player_service.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_service.dart';

class NotificationOverlayViewModel {
  NotificationOverlayViewModel({
    required NotificationService notificationService,
    required AudioPlayerService audioPlayerService,
  }) : _notificationService = notificationService,
       _audioPlayerService = audioPlayerService;

  final NotificationService _notificationService;
  final AudioPlayerService _audioPlayerService;

  ValueListenable<ToastMessage?> get toastNotifier =>
      _notificationService.toastNotifier;

  ValueListenable<AudioFile?> get nowPlaying =>
      _audioPlayerService.currentTrack;

  void showToast(String message) {
    _notificationService.show(message);
  }

  void clearToast() {
    _notificationService.clear();
  }
}
