import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rec_sesh/features/audio_player/application/audio_player_service.dart';
import 'package:rec_sesh/features/projects/data/project_track_repository.dart';
import 'package:rec_sesh/features/projects/domain/audio_track.dart';

class UnassignedTracksViewModel {
  UnassignedTracksViewModel({
    required ProjectTrackRepository projectTrackRepo,
    required AudioPlayerService audioPlayerService,
  }) : _projectTrackRepo = projectTrackRepo,
       _audioPlayerService = audioPlayerService;

  final _log = Logger('$UnassignedTracksViewModel');
  final ProjectTrackRepository _projectTrackRepo;
  final AudioPlayerService _audioPlayerService;

  final _isEditMode = ValueNotifier<bool>(false);
  final _selectedRecordingIds = ValueNotifier<Set<String>>({});

  ValueListenable<bool> get isEditMode => _isEditMode;
  ValueListenable<Set<String>> get selectedTracks => _selectedRecordingIds;
  ValueListenable<List<AudioFile>> get unassignedTracks =>
      _projectTrackRepo.unassignedTracks;

  Future<void> fetchUnassignedTracks() async {
    _projectTrackRepo.getUnassignedRecordings();
  }

  void playTrack(AudioFile audioTrack) {
    _audioPlayerService.playTrack(audioTrack);
  }

  void enterEditMode(String trackId) {
    _isEditMode.value = true;
    _selectedRecordingIds.value = {trackId};
  }

  void exitEditMode() {
    _isEditMode.value = false;
    _selectedRecordingIds.value = {};
  }

  void toggleSelection(String trackId) {
    final currentSelection = Set<String>.from(_selectedRecordingIds.value);
    if (currentSelection.contains(trackId)) {
      currentSelection.remove(trackId);
    } else {
      currentSelection.add(trackId);
    }
    _selectedRecordingIds.value = currentSelection;

    // Exit edit mode if no items are selected
    if (_isEditMode.value && currentSelection.isEmpty) {
      exitEditMode();
    }
  }

  void deleteSelection() {
    _log.info('Deleting ${_selectedRecordingIds.value.length} track(s)');
    _projectTrackRepo.deleteTracks(_selectedRecordingIds.value);
    exitEditMode();
  }
}
