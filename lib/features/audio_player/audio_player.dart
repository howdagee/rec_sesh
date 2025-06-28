import 'package:flutter/material.dart';
import 'package:rec_sesh/core/services/audio_player_service.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/utils/extensions.dart';
import 'package:rec_sesh/core/utils/helpers.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/features/audio_player/audio_player_view_model.dart';
import 'package:rec_sesh/features/audio_player/circular_progress_painter.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({super.key});

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  late final _vmAudioPlayer = AudioPlayerViewModel(
    audioPlayerService: locator<AudioPlayerService>(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTrack = _vmAudioPlayer.currentTrack.value;
    final textStyles = context.textStyles;
    return Container(
      margin: const EdgeInsets.only(
        bottom: Sizes.p40,
        left: Sizes.p10,
        right: Sizes.p10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p12,
        vertical: Sizes.p12,
      ),
      decoration: BoxDecoration(
        color: RecColors.dark,
        border: Border.all(
          color: RecColors.secondary.withValues(alpha: .5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(Sizes.p16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        // Main row for player layout
        children: [
          // Track Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentTrack?.name ?? '',
                  style: textStyles.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                ValueListenableBuilder(
                  valueListenable: _vmAudioPlayer.currentPosition,
                  builder: (context, currentPosition, child) {
                    return Text(
                      '${formatDuration(currentPosition)} / ${formatDuration(currentTrack?.duration ?? Duration.zero)}', // Show current/total time
                      style: textStyles.xs.copyWith(color: RecColors.grey),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: Sizes.p16),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  color: RecColors.secondary,
                  size: 28,
                ),
                onPressed: () {
                  // Logic for previous track
                },
              ),
              // Central Play/Pause button with circular progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 54, // Size of the circular container
                    height: 54,
                    child: ValueListenableBuilder(
                      valueListenable: _vmAudioPlayer.progressPosition,
                      builder: (context, position, child) {
                        return CustomPaint(
                          painter: CircularProgressPainter(
                            progress: position,
                            activeColor: RecColors.primary,
                            inactiveColor: RecColors.secondary.withValues(
                              alpha: 0.3,
                            ),
                            strokeWidth: 3.0,
                          ),
                        );
                      },
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _vmAudioPlayer.isPlaying,
                    builder: (context, isPlaying, child) {
                      return IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: RecColors.primary,
                          size: 42, // Size of the icon
                        ),
                        onPressed: _vmAudioPlayer.playPauseToggled,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(width: Sizes.p4),
              TextButton(
                onPressed: _vmAudioPlayer.skipSeconds,
                child: Text(
                  '+10s',
                  style: context.textStyles.titleSmall.copyWith(
                    color: RecColors.secondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
