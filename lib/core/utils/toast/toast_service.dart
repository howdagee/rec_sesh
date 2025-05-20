import 'package:flutter/material.dart';

class ToastMessage {
  final String message;
  final Duration duration;

  ToastMessage(this.message, {this.duration = const Duration(seconds: 4)});
}

class ToastService {
  final ValueNotifier<ToastMessage?> _toastNotifier = ValueNotifier(null);
  ValueNotifier<ToastMessage?> get toastNotifier => _toastNotifier;

  void show(String message, {Duration? duration}) {
    _toastNotifier.value = ToastMessage(
      message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void dispose() {
    _toastNotifier.dispose();
  }
}
