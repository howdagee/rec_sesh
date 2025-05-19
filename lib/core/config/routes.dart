import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/home_view/home_view.dart';
import 'package:rec_sesh/not_found/not_found_view.dart';

final routes = [
  RouteEntry(path: '/', builder: (key, routeData) => const HomeView()),
  RouteEntry(path: '/404', builder: (key, routeData) => const NotFoundView()),
];
