import 'package:flutter/material.dart';
import 'package:rec_sesh/core/utils/l10n/app_localizations.dart';

extension Translate on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this);
}
