import 'package:flutter/material.dart';
import 'package:rec_sesh/core/utils/navigation/url_strategy/url_strategy.dart';
import 'package:rec_sesh/features/common/startup/startup_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();
  runApp(const StartupView());
}
