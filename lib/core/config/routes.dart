import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/features/projects/presentation/projects_list/project_list_screen.dart';
import 'package:rec_sesh/features/common/not_found/not_found_view.dart';
import 'package:rec_sesh/features/common/settings/settings_view.dart';

final routes = [
  RouteEntry(path: '/', builder: (key, routeData) => const ProjectListScreen()),
  RouteEntry(path: '/404', builder: (key, routeData) => const NotFoundView()),
  RouteEntry(
    path: '/settings',
    builder: (key, routeData) => const SettingsScreen(),
  ),
];
