
import 'package:flutter/foundation.dart';
import 'package:rec_sesh/core/utils/toast/toast_service.dart';

class ToastOverlayViewModel {
  ToastOverlayViewModel({required ToastService toastService})
    : _toastService = toastService;

  final ToastService _toastService;

  ValueNotifier<ToastMessage?> get toastNotifier => _toastService.toastNotifier;

  void showToast(String message) {
    _toastService.show(message);
  }

  void clearToast() {
    _toastService.toastNotifier.value = null;
  }
}