import 'package:flutter/material.dart';
import 'package:rec_sesh/features/audio_player/application/audio_player_service.dart';
import 'package:rec_sesh/core/theme/rec_colors.dart';
import 'package:rec_sesh/core/theme/sizes.dart';
import 'package:rec_sesh/core/utils/extensions.dart';
import 'package:rec_sesh/core/utils/locator.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_overlay_view_model.dart';
import 'package:rec_sesh/features/common/notification_overlay/notification_service.dart';
import 'package:rec_sesh/features/audio_player/presentation/audio_player_widget.dart';

class NotificationOverlay extends StatefulWidget {
  final Widget child;

  const NotificationOverlay({super.key, required this.child});

  @override
  State<NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay> {
  late final NotificationOverlayViewModel _viewModel =
      NotificationOverlayViewModel(
        notificationService: locator<NotificationService>(),
        audioPlayerService: locator<AudioPlayerService>(),
      );
  double _dragOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _viewModel.nowPlaying,
        builder: (context, currentTrack, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1.5),
                    end: const Offset(0, 0),
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
                currentTrack == null
                    ? const SizedBox.shrink(key: ValueKey<bool>(false))
                    : ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: context.breakpoints.sm,
                      ),
                      child: AudioPlayerWidget(key: ValueKey<bool>(true)),
                    ),
          );
        },
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: RecColors.dark,
          ),
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
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
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
                            onDismiss: _viewModel.clearToast,
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
      ),
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
          constraints: BoxConstraints(maxWidth: context.breakpoints.lg),
          child: GestureDetector(
            onVerticalDragStart: onVerticalDragStart,
            onVerticalDragUpdate: onVerticalDragUpdate,
            child: Container(
              margin: EdgeInsets.all(Sizes.p16),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: RecColors.secondary,
                    border: Border.all(width: 1, color: RecColors.dark),
                    borderRadius: BorderRadius.circular(Sizes.p10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes.p24,
                      vertical: Sizes.p16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            toastMessage.message,
                            style: context.textStyles.standard,
                          ),
                        ),
                      ],
                    ),
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
