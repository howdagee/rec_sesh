import 'package:flutter/foundation.dart';
import 'package:rec_sesh/core/utils/navigation/navigation_observable.dart';
import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/core/utils/navigation/utils.dart';

/// Service responsible for managing navigation state
class RouterService with ObservableRouter {
  RouterService({required this.supportedRoutes}) {
    _navigationStack.value = [_createRouteData(RecPath(name: '/'))];
  }

  final _navigationStack = ValueNotifier<List<RouteData>>([]);
  ValueNotifier<List<RouteData>> get navigationStack => _navigationStack;

  final List<RouteEntry> supportedRoutes;

  void goTo(RecPath path) {
    if (_pathNotSupported(path.name)) {
      _handlePathNotSupported();
      return;
    }

    final newRoute = _createRouteData(path);
    _navigationStack.value = [..._navigationStack.value, newRoute];
    notifyPush(newRoute);
  }

  void replace(RecPath path) {
    if (_pathNotSupported(path.name)) {
      _handlePathNotSupported();
      return;
    }

    final newRoute = _createRouteData(path);
    _navigationStack.value = [
      ..._navigationStack.value.sublist(0, _navigationStack.value.length - 1),
      newRoute,
    ];
    notifyReplace([newRoute]);
  }

  void back() {
    if (_navigationStack.value.length <= 1) {
      return;
    }

    final poppedRoute = _navigationStack.value.last;
    _navigationStack.value = _navigationStack.value.sublist(
      0,
      _navigationStack.value.length - 1,
    );
    notifyPop(poppedRoute);
  }

  void replaceAll(List<RecPath> routeDatas) {
    final newRoutes = <RouteData>[];
    for (final routeData in routeDatas) {
      if (_pathNotSupported(routeData.name)) {
        _handlePathNotSupported();
        return;
      }

      final newRoute = _createRouteData(routeData);
      newRoutes.add(newRoute);
    }
    _navigationStack.value = newRoutes;
    notifyReplace(newRoutes);
  }

  void backUntil(RecPath path) {
    if (!_existsInStack(path.name)) {
      return;
    }

    final indexToKeep = _navigationStack.value.indexWhere(
      (r) => r.pathWithParams == path.name,
    );
    final removedRoutes = _navigationStack.value.sublist(indexToKeep + 1);
    _navigationStack.value = _navigationStack.value.sublist(0, indexToKeep + 1);

    // Notify about each removed route
    for (final route in removedRoutes.reversed) {
      notifyPop(route);
    }
  }

  /// Rebuilds the navigation stack to end at the specified route.
  /// This is typically used by setNewRoutePath to handle browser history changes.
  void replaceAllWithRoute(RouteData resolvedRoute) {
    if (_pathNotSupported(resolvedRoute.pathWithParams)) {
      _handlePathNotSupported();
      return;
    }

    // When restoring from URL, extra is typically not available.
    // We use the resolvedRoute directly, which might or might not have extra 
    // depending on how it was created before serialization. If RouteData came
    // from AppRouteInformationParser, it won't have extra.
    _navigationStack.value = [resolvedRoute];
    notifyReplace([resolvedRoute]);
  }

  void remove(RecPath path) {
    if (!_existsInStack(path.name)) return;

    final routeToRemove = _navigationStack.value.firstWhere(
      (route) => route.pathWithParams == path.name,
    );
    _navigationStack.value =
        _navigationStack.value
            .where((route) => route.pathWithParams != path.name)
            .toList();
    notifyRemove(routeToRemove);
  }

  bool _existsInStack(String path) {
    final uri = Uri.parse(path);
    return _navigationStack.value.any((route) => route.uri == uri);
  }

  bool _pathNotSupported(String path) {
    final uri = Uri.parse(path);
    return !supportedRoutes.any((r) => matchRoute(r.path, uri));
  }

  void _handlePathNotSupported() {
    final notFoundRoute = _createRouteData(RecPath(name: '/404'));
    _navigationStack.value = [..._navigationStack.value, notFoundRoute];
    notifyPush(notFoundRoute);
  }

  RouteData _createRouteData(RecPath path) {
    final uri = Uri.parse(path.name);
    return RouteData(
      uri: uri,
      routePattern: findMatchingRoutePattern(uri, supportedRoutes),
      extra: path.extra,
    );
  }
}
