import 'package:flutter/material.dart';
import 'package:rec_sesh/features/audio_recorder/application/recorder_service.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/utils/extensions.dart';
import 'package:rec_sesh/core/utils/helpers.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/features/audio_recorder/presentation/widgets/fake_audio_visualizer.dart';
import 'package:rec_sesh/features/audio_recorder/presentation/new_recording_view_model.dart';

class NewRecordingScreen extends StatefulWidget {
  const NewRecordingScreen({super.key});

  @override
  State<NewRecordingScreen> createState() => _NewRecordingScreenState();
}

class _NewRecordingScreenState extends State<NewRecordingScreen> {
  late final _vmRecordingScreen = NewRecordingViewModel(
    routerService: locator<RouterService>(),
    recorderService: locator<RecorderService>(),
  );

  @override
  void initState() {
    super.initState();
    _vmRecordingScreen.init();
  }

  void _confirmDeleteRecording() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: RecColors.surface,
          title: Text(
            'Delete Recording?'.hardCoded,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete this recording? This action cannot be undone.'
                .hardCoded,
            style: context.textStyles.standard.copyWith(color: RecColors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: RecColors.grey),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _vmRecordingScreen.deleteRecording();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: RecColors.red),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _vmRecordingScreen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final textStyle = context.textStyles;

    return Container(
      height: screenHeight,
      color: RecColors.dark,
      child: Column(
        children: [
          AppBar(
            backgroundColor: RecColors.darkMedium,
            foregroundColor: RecColors.light,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _confirmDeleteRecording,
            ),
            title: Text('New Recording'.hardCoded),
            centerTitle: true,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: _vmRecordingScreen.isPaused,
                  builder: (context, isPaused, child) {
                    return Text(
                      isPaused ? 'Paused' : 'Recording'.hardCoded,
                      style: textStyle.titleLarge.copyWith(
                        color: isPaused ? RecColors.grey : RecColors.primary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: _vmRecordingScreen.recordingDuration,
                  builder: (context, duration, child) {
                    return Text(
                      formatDuration(duration),
                      style: textStyle.headline,
                    );
                  },
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: RecColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: _vmRecordingScreen.isPaused,
                    builder: (context, isPaused, child) {
                      return FakeAudioVisualizer(
                        isPaused: isPaused,
                        height: 100.0,
                        barColor: RecColors.primary,
                      );
                    },
                  ),
                ),
                Text(
                  'Placeholder Visualizer'.hardCoded,
                  style: context.textStyles.xs.copyWith(color: RecColors.grey),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: _confirmDeleteRecording,
                  style: TextButton.styleFrom(foregroundColor: RecColors.light),
                  child: const Text(
                    'DELETE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _vmRecordingScreen.isPaused,
                  builder: (context, isPaused, child) {
                    return ElevatedButton(
                      onPressed: _vmRecordingScreen.toggleRecordPause,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RecColors.red,
                        foregroundColor: RecColors.light,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          isPaused
                              ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  'RESUME'.hardCoded,
                                  style: context.textStyles.titleLarge,
                                ),
                              )
                              : Icon(Icons.pause, size: Sizes.p34),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    _vmRecordingScreen.saveRecording();
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(foregroundColor: RecColors.light),
                  child: Text(
                    'SAVE'.hardCoded,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.p64),
        ],
      ),
    );
  }
}
