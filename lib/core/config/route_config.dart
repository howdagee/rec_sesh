import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/features/audio_recorder/presentation/new_recording_page.dart';
import 'package:rec_sesh/features/common/not_found/not_found_view.dart';
import 'package:rec_sesh/features/settings/settings_page.dart';
import 'package:rec_sesh/features/projects/presentation/unassigned_tracks/unassigned_tracks_page.dart';

abstract class RecRoute {
  static const String home = '/';
  static const String project = '/project';
  static const String notFound = '/404';
  static const String settings = '/settings';
  static const String newRecording = '/newRecording';
  static const String unassignedRecordings = '/unassignedRecordings';
}

final routes = [
  RouteEntry(
    path: RecRoute.home,
    builder: (key, routeData) => const UnassignedTracksPage(),
    // TODO(JDJ): Implement the projects feature and add ProjectListPage as home
    // builder: (key, routeData) => const ProjectListPage(),
  ),
  RouteEntry(
    path: RecRoute.notFound,
    builder: (key, routeData) => const NotFoundView(),
  ),
  RouteEntry(
    path: RecRoute.settings,
    builder: (key, routeData) => const SettingsScreen(),
  ),
  RouteEntry(
    path: RecRoute.newRecording,
    builder: (key, routeData) => const NewRecordingScreen(),
  ),
  // RouteEntry(
  //   path: RecRoute.unassignedRecordings,
  //   builder: (key, routeData) => const UnassignedTracksPage(),
  // ),
];
