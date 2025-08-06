import 'package:flutter/material.dart';
import 'package:rec_sesh/core/utils/extensions.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textStyles;

    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: textTheme.headline)),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        child: Text('Settings Page Content', style: textTheme.titleLarge),
      ),
    );
  }
}
