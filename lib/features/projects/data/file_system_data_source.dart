import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:rec_sesh/core/exceptions/project_exception.dart';
import 'package:rec_sesh/core/models/audio_track.dart';
import 'package:rec_sesh/core/models/project.dart';
import 'package:rec_sesh/core/utils/time_formatter.dart';

/// A wrapper around path_provider and path packages, to help with managing
/// projects and tracks.
class FileSystemDataSource {
  FileSystemDataSource();

  final _log = Logger('$FileSystemDataSource');

  /// The folder name for the main directory where all project (directories) are
  /// created.
  static const _baseAppDirectory = 'rec_sesh_projects';

  /// The name of the directory where all unassigned tracks are saved.
  static const _unassignedTracksDirectory = 'unassigned_tracks';
  String? _cachedProjectsPath;

  Future<String> get _getBaseProjectsPath async =>
      _cachedProjectsPath ??= p.join(
        (await getApplicationDocumentsDirectory()).path,
        _baseAppDirectory,
      );

  /// Retrieves the path for unassigned recordings and generates a DateTime
  /// to be used for the filename.
  String generatePathForRecording(String fileExtension) {
    final weekdayAndTime = DateTimeFormatter.getWeekdayAtTime(DateTime.now());

    final savePath = p.join(
      _cachedProjectsPath!,
      _unassignedTracksDirectory,
      '$weekdayAndTime.$fileExtension',
    );

    _log.info('Saving quick recording to: $savePath');

    return savePath;
  }

  /// Checks if the provided [projectName] already exists as a
  /// directory.
  Future<bool> projectExists(String projectName) async {
    return (await _getProjectDirectory(projectName)).exists();
  }

  /// Create a directory with the provided [projectName].
  ///
  /// Throws a [CreateDirectoryException] if there is n error creating the
  /// directory, or [DirectoryAlreadyExistsException] if the directory already
  /// exists.
  Future<void> createProject(String projectName) async {
    if (await projectExists(projectName)) {
      throw ProjectAlreadyExistsException();
    }

    try {
      // Attempt to create the project directory.
      (await _getProjectDirectory(projectName)).createSync(recursive: true);
    } on FileSystemException catch (e, stack) {
      _log.severe(
        'FileSystemException on creating project $projectName',
        stack,
      );
      throw CreateProjectException();
    }
  }

  /// Creates the root directory where all project directories are stored and
  /// the directory for unassigned tracks.
  Future<void> init() async {
    _log.info('Initializing root path for projects');
    Directory(await _getBaseProjectsPath).createSync();
    Directory(
      p.join(await _getBaseProjectsPath, _unassignedTracksDirectory),
    ).createSync();
  }

  /// Delete a directory matching the [projectName] provided.
  Future<void> deleteProject(String projectName) async {
    try {
      final projectDirectory = (await _getProjectDirectory(projectName));
      projectDirectory.deleteSync(recursive: true);
    } on FileSystemException catch (e) {
      _log.warning('Exception: deleteDirectoryByName $e - ${e.path}');
      rethrow;
    }
  }

  Future<List<Project>> getProjects() async {
    try {
      final projectsDirectory =
          Directory(await _getBaseProjectsPath).listSync();

      final projects =
          projectsDirectory.map((projectDirectory) {
            return Project(
              name: p.basenameWithoutExtension(projectDirectory.path),
              path: projectDirectory.path,
              dateModified: projectDirectory.statSync().modified,
            );
          }).toList();
      _log.info('getProjects() - ${projects.length} project(s)');

      return projects;
    } on PathNotFoundException catch (e) {
      _log.info('Failed to get directory names at root: $e');
      rethrow;
    }
  }

  Future<List<AudioFile>> getTracksForProject(String projectName) async {
    try {
      final projectDirectory = await _getProjectDirectory(projectName);
      final tracks =
          projectDirectory
              .listSync(recursive: true)
              .map(
                (element) => AudioFile(
                  name: p.basenameWithoutExtension(element.path),
                  dateCreated: element.statSync().modified,
                ),
              )
              .toList();

      return tracks;
    } on PathNotFoundException catch (e, stack) {
      _log.severe(
        'Exception: Could not retrieve List<AudioTrackFile> $e',
        stack,
      );
      rethrow;
    } on FileSystemException catch (e, stack) {
      _log.shout(
        'Exception: Could not retrieve List<AudioTrackFile> $e',
        stack,
      );
      rethrow;
    }
  }

  Future<Directory> _getProjectDirectory(String projectName) async =>
      Directory(p.join(await _getBaseProjectsPath, projectName));
}
