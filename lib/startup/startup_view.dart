import 'package:flutter/material.dart';
import 'package:rec_sesh/core/utils/l10n/app_localizations.dart';
import 'package:rec_sesh/core/utils/l10n/translate_extension.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/rec_router_config.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/core/utils/toast/toast_overlay.dart';
import 'package:rec_sesh/startup/startup_app_state.dart';
import 'package:rec_sesh/startup/startup_view_model.dart';

/// Responsible for initializing services and setting up the directories
/// for project.
class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  late final _viewModel = StartupViewModel();
  late final RecRouterConfig _recRouterConfig;

  @override
  void initState() {
    super.initState();
    _viewModel.initializeApp();
    _recRouterConfig = RecRouterConfig(routerService: locator<RouterService>());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _viewModel.appStateNotify,
      builder: (context, state, _) {
        return MaterialApp.router(
          routerConfig: _recRouterConfig,
          onGenerateTitle: (context) => context.translate.appName,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          builder:
              (context, router) => switch (state) {
                InitializingApp() => _SplashView(),
                AppInitialized() => ToastOverlay(child: router!),
                AppInitializationError() => _StartupErrorView(
                  onRetry: _viewModel.retryInitialization,
                ),
              },
        );
      },
    );
  }
}

class _StartupErrorView extends StatelessWidget {
  const _StartupErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 12),
              Text('An error occurred', textAlign: TextAlign.center),
              SizedBox(height: 8),
              Text('Error starting app', textAlign: TextAlign.center),
              SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text('retry'),
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
