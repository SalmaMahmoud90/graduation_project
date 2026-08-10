import 'package:a_tareqaak/core/helper/local_storage_helper.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit({Locale initialLocale = const Locale('ar')}) : super(initialLocale);

  static const String boxName = 'settings';
  static const String localeKey = 'locale';
  static const List<String> supportedLocales = ['ar', 'en'];

  final LocalStorageHelper _storage = locator<LocalStorageHelper>();

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale.languageCode)) {
      return;
    }
    if (state.languageCode == locale.languageCode) {
      return;
    }
    emit(locale);
    await _storage.saveValue(boxName, localeKey, locale.languageCode);
  }
  // إمكانية تبديل اللغة بين العربية والإنجليزية بسهولة
void toggleLanguage() {
  if (state.languageCode == 'ar') {
    setLocale(const Locale('en')); // أو emit(const Locale('en')) حسب تعريف الكيوبيت لديكم
  } else {
    setLocale(const Locale('ar')); // أو emit(const Locale('ar'))
  }
}
}
