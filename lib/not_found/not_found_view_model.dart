import 'package:rec_sesh/core/utils/navigation/route_data.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';

class NotFoundViewModel {
  final RouterService _routerService;

  NotFoundViewModel({required RouterService routerService})
    : _routerService = routerService;

  void navigateToHome() {
    _routerService.replaceAll([RecPath(name: '/')]);
  }
}
