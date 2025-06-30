import 'package:flutter/material.dart';

class ToastMessage {
  final String message;
  final Duration duration;

  ToastMessage(this.message, {this.duration = const Duration(seconds: 4)});
}

class NotificationService {
  final ValueNotifier<ToastMessage?> _toastNotifier = ValueNotifier(null);
  ValueNotifier<ToastMessage?> get toastNotifier => _toastNotifier;

  void show(String message, {Duration? duration}) {
    _toastNotifier.value = ToastMessage(
      message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void clear() {
    _toastNotifier.value = null;
  }

  void dispose() {
    _toastNotifier.dispose();
  }
}
