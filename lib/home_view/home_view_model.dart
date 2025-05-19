import 'package:flutter/foundation.dart';
import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';

/// Manages the dog image gallery for the home screen
class HomeViewModel {
  final RouterService _routerService;

  HomeViewModel({
    required RouterService routerService,
  }) : _routerService = routerService;

  final ValueNotifier<int> counter = ValueNotifier<int>(0);

  void increment() {
    counter.value++;

    if (counter.value % 10 == 0) {
      // Simple test to confirm the RouterService is working correctly.
      _routerService.goTo(RecPath(name: '/404'));
    }
  }

  void dispose() {
    counter.dispose();
  }
}
