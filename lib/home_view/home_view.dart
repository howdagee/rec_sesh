import 'package:flutter/material.dart';
import 'package:rec_sesh/core/utils/l10n/translate_extension.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/core/utils/toast/toast_service.dart';
import 'package:rec_sesh/home_view/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _viewModel = HomeViewModel(
    routerService: locator<RouterService>(),
  );

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RecSesh')),
      body: SafeArea(
        child: Center(
          child: ValueListenableBuilder<int>(
            valueListenable: _viewModel.counter,
            builder: (context, count, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.translate.counter, textAlign: TextAlign.center),
                  Text('$count', textAlign: TextAlign.center),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewModel.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
