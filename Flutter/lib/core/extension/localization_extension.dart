// lib/core/extensions/localization_extension.dart
import 'package:a_tareqaak/core/l10n/app_localizations.dart' show AppLocalizations;
import 'package:flutter/widgets.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
