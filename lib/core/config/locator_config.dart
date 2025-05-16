import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/main.dart';

// TODO(JDJ): Create other versions of this list for different flavors of the
//   app.

/// This is the list of modules that will be used in the app. Each module
///   contains a list of services that will be registered in the locator.
final modules = [
  Module<SomeService>(builder: () => SomeService(), lazy: true),
  // TODO(JDJ): Add logging service to dependency injection system.
];
