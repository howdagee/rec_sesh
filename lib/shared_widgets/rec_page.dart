import 'package:flutter/material.dart';
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/utils/extensions.dart';
import 'package:rec_sesh/shared_widgets/content_container.dart';

class RecPage extends StatelessWidget {
  const RecPage({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    return SafeArea(
      child: ContentContainer(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title, style: textStyles.headline),
            actions: [...?actions, SizedBox(width: Sizes.p10)],
          ),
          body: ContentContainer(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: body,
            ),
          ),
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
