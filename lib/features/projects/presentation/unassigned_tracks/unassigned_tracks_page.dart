import 'package:flutter/material.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/utils/extensions.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/features/audio_player/application/audio_player_service.dart';
import 'package:rec_sesh/features/audio_recorder/presentation/new_recording_page.dart';
import 'package:rec_sesh/features/projects/data/project_track_repository.dart';
import 'package:rec_sesh/features/projects/presentation/unassigned_tracks/unassigned_tracks_view_model.dart';
import 'package:rec_sesh/shared_widgets/rec_list_tile.dart';
import 'package:rec_sesh/shared_widgets/rec_page.dart';

class UnassignedTracksPage extends StatefulWidget {
  const UnassignedTracksPage({super.key});

  @override
  State<UnassignedTracksPage> createState() => _UnassignedTracksPageState();
}

class _UnassignedTracksPageState extends State<UnassignedTracksPage> {
  late final _vmUnassignedTracks = UnassignedTracksViewModel(
    projectTrackRepo: locator<ProjectTrackRepository>(),
    audioPlayerService: locator<AudioPlayerService>(),
  );

  @override
  void initState() {
    super.initState();
    _vmUnassignedTracks.fetchUnassignedTracks();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    return ValueListenableBuilder(
      valueListenable: _vmUnassignedTracks.selectedTracks,
      builder:
          (context, selectedTracks, _) => RecPage(
            title: 'Unassigned Tracks',
            actions: [
              if (selectedTracks.isNotEmpty) ...[
                IconButton(
                  onPressed: _vmUnassignedTracks.exitEditMode,
                  icon: Icon(Icons.remove_circle_outline, size: Sizes.p34),
                ),
                IconButton(
                  icon: Icon(Icons.delete, size: Sizes.p34),
                  color: Colors.red,
                  onPressed: _vmUnassignedTracks.deleteSelection,
                ),
              ],
            ],
            body: ValueListenableBuilder(
              valueListenable: _vmUnassignedTracks.unassignedTracks,
              builder: (context, audioTracks, child) {
                return ListView.builder(
                  itemCount: audioTracks.length,
                  itemBuilder: (context, index) {
                    final audioTrack = audioTracks[index];
                    return RecListTile(
                      key: ValueKey(audioTrack),
                      onTap: () {
                        if (_vmUnassignedTracks.isEditMode.value) {
                          _vmUnassignedTracks.toggleSelection(audioTrack.name);
                        }
                      },
                      selected: _vmUnassignedTracks.selectedTracks.value
                          .contains(audioTrack.name),
                      onLongPress:
                          () => _vmUnassignedTracks.enterEditMode(
                            audioTrack.name,
                          ),
                      title: audioTrack.name,
                      leadingIcon: Icons.mic,
                      trailing: IconButton(
                        icon: Icon(
                          Icons.play_circle_fill,
                          color: RecColors.primary,
                          size: 32,
                        ),
                        onPressed:
                            () => _vmUnassignedTracks.playTrack(audioTrack),
                      ),
                      subtitle: Text(
                        audioTrack.createdAt,
                        style: textStyles.xs.copyWith(color: RecColors.grey),
                      ),
                    );
                  },
                );
              },
            ),
            floatingActionButton: Padding(
              padding: EdgeInsetsGeometry.only(
                bottom: Sizes.p24,
                right: Sizes.p16,
              ),
              child: FloatingActionButton(
                onPressed: _openFullScreenRecordSheet,
                backgroundColor: RecColors.red,
                elevation: 6,
                child: const Icon(Icons.mic, color: RecColors.light, size: 32),
              ),
            ),
          ),
    );
  }

  void _openFullScreenRecordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(child: const NewRecordingScreen());
      },
    );
  }
}
