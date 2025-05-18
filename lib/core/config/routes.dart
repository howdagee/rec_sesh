import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/main.dart';

final routes = [
  RouteEntry(path: '/', builder:(key, routeData) => const MyHomePage(),),
  // TODO(JDJ): Create a simple 404 page not found.
  // RouteEntry(path: '/404', builder: (key, routeData) => const NotFoundView())
];
