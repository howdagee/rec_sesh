import 'package:flutter/material.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/core/utils/toast/toast_overlay_view_model.dart';
import 'package:rec_sesh/core/utils/toast/toast_service.dart';

class ToastOverlay extends StatefulWidget {
  final Widget child;

  const ToastOverlay({super.key, required this.child});

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay> {
  late final ToastOverlayViewModel _viewModel = ToastOverlayViewModel(
    toastService: locator<ToastService>(),
  );
  double _dragOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<ToastMessage?>(
            valueListenable: _viewModel.toastNotifier,
            builder: (context, toastMessage, _) {
              if (toastMessage != null) {
                Future.delayed(toastMessage.duration, () {
                  if (mounted &&
                      _viewModel.toastNotifier.value == toastMessage) {
                    _viewModel.clearToast();
                  }
                });
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                          reverseCurve: Curves.easeIn,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child:
                    toastMessage == null
                        ? const SizedBox.shrink()
                        : _Toast(
                          key: ValueKey(toastMessage.message),
                          toastMessage: toastMessage,
                          onDismiss: () {
                            _viewModel.clearToast();
                          },
                          onVerticalDragStart: (_) => _dragOffset = 0,
                          onVerticalDragUpdate: (details) {
                            _dragOffset += details.primaryDelta!;
                            if (_dragOffset < -20) {
                              _viewModel.clearToast();
                            }
                          },
                        ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Toast extends StatelessWidget {
  final ToastMessage toastMessage;
  final VoidCallback onDismiss;
  final GestureDragStartCallback onVerticalDragStart;
  final GestureDragUpdateCallback onVerticalDragUpdate;

  const _Toast({
    super.key,
    required this.toastMessage,
    required this.onDismiss,
    required this.onVerticalDragStart,
    required this.onVerticalDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 960),
          child: GestureDetector(
            onVerticalDragStart: onVerticalDragStart,
            onVerticalDragUpdate: onVerticalDragUpdate,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [Expanded(child: Text(toastMessage.message))],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
