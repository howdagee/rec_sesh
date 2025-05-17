import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rec_sesh/core/utils/navigation/route_information_parser.dart';
import 'package:rec_sesh/core/utils/navigation/router_delegate.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';

class RecRouterConfig extends RouterConfig<Object> {
  RecRouterConfig({required RouterService routerService})
    : super(
        routerDelegate: AppRouterDelegate(routerService: routerService),
        routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(
            uri: Uri.parse(PlatformDispatcher.instance.defaultRouteName),
          ),
        ),
        backButtonDispatcher: RootBackButtonDispatcher(),
        routeInformationParser: AppRouteInformationParser(
          routes: routerService.supportedRoutes,
        ),
      );
}
