import 'package:flutter/material.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/rec_theme.dart';
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/utils/extensions.dart';
import 'package:rec_sesh/core/utils/l10n/app_localizations.dart';
import 'package:rec_sesh/core/utils/l10n/translate_extension.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/rec_router_config.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_overlay.dart';
import 'package:rec_sesh/features/common/startup/startup_app_state.dart';
import 'package:rec_sesh/features/common/startup/startup_view_model.dart';

/// Responsible for initializing services and setting up the directories
/// for project.
class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  late final _vmStartup = StartupViewModel();
  late final RecRouterConfig _recRouterConfig;

  @override
  void initState() {
    super.initState();
    _vmStartup.initializeApp();
    _recRouterConfig = RecRouterConfig(routerService: locator<RouterService>());
  }

  @override
  void dispose() {
    _vmStartup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _vmStartup.appStateNotify,
      builder: (context, state, _) {
        return MaterialApp.router(
          routerConfig: _recRouterConfig,
          onGenerateTitle: (context) => context.translate.appName,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: RecTheme.buildTheme(Brightness.dark),
          builder:
              (context, router) => switch (state) {
                InitializingApp() => _SplashView(),
                AppInitialized() => NotificationOverlay(child: router!),
                AppInitializationError(error: final error) => _StartupErrorView(
                  onRetry: _vmStartup.retryInitialization,
                  error: error,
                ),
              },
        );
      },
    );
  }
}

class _StartupErrorView extends StatelessWidget {
  const _StartupErrorView({required this.onRetry, this.error});

  final VoidCallback onRetry;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Sizes.p12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: RecColors.red, size: Sizes.p40),
              SizedBox(height: 12),
              Text('An error occurred'.hardCoded, textAlign: TextAlign.center),
              Text('Error starting app'.hardCoded, textAlign: TextAlign.center),
              SizedBox(height: 8),
              Text('$error'.hardCoded, textAlign: TextAlign.center),
              SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text('retry'.hardCoded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
