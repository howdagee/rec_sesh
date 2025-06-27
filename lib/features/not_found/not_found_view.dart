import 'package:flutter/material.dart';
import '/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/navigation/router_service.dart';
import 'package:rec_sesh/features/not_found/not_found_view_model.dart';

class NotFoundView extends StatefulWidget {
  const NotFoundView({super.key});

  @override
  State<NotFoundView> createState() => _NotFoundViewState();
}

class _NotFoundViewState extends State<NotFoundView> {
  late final NotFoundViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NotFoundViewModel(routerService: locator<RouterService>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '404',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text('Page not found', textAlign: TextAlign.center),
              SizedBox(height: 24),
              OutlinedButton(
                onPressed: _viewModel.navigateToHome,
                child: Text('Go home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
