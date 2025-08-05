import 'package:flutter/foundation.dart';
import 'package:rec_sesh/features/projects/domain/audio_track.dart';
import 'package:rec_sesh/features/projects/domain/project.dart';
import 'package:rec_sesh/features/projects/data/file_system_data_source.dart';

/// Repository for managing projects and the corresponding audio files.
class ProjectTrackRepository {
  ProjectTrackRepository({required FileSystemDataSource projectTrackDataSource})
    : _projectTrackDataSource = projectTrackDataSource;

  final FileSystemDataSource _projectTrackDataSource;
  final _currentProject = ValueNotifier<Project?>(null);
  final _projects = ValueNotifier<List<Project>>([]);
  final _unassignedTracks = ValueNotifier<List<AudioFile>>([]);
  final _recentRecordings = ValueNotifier<List<AudioFile>>([]);

  ValueListenable<List<Project>> get projects => _projects;
  ValueListenable<List<AudioFile>> get unassignedTracks => _unassignedTracks;
  ValueListenable<List<AudioFile>> get recentRecordings => _recentRecordings;
  ValueListenable<Project?> get currentProject => _currentProject;

  Future<void> getProjectsList() async {
    _projects.value = await _projectTrackDataSource.getProjects();
  }

  Future<String> getPathForNewRecording() async {
    return _projectTrackDataSource.generatePathForRecording(
      selectedProject: _currentProject.value,
    );
  }

  Future<void> getRecentRecordings({int? limit}) async {
    _recentRecordings.value =
        await _projectTrackDataSource.getRecentRecordings();
  }

  Future<void> getUnassignedRecordings() async {
    _unassignedTracks.value =
        await _projectTrackDataSource.getUnassignedRecordings();
  }

  void deleteTracks(Set<String> selectedTrackIds) {
    _projectTrackDataSource.deleteSelectedTracks(
      selectedTrackIds,
      currentProject.value,
    );
    getUnassignedRecordings();
  }
}
