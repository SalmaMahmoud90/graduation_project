import 'package:a_tareqaak/core/helper/local_storage_helper.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({ThemeMode initialThemeMode = ThemeMode.light}) : super(initialThemeMode);

  static const String boxName = 'settings';
  static const String themeModeKey = 'theme_mode';
  static const String lightValue = 'light';
  static const String darkValue = 'dark';
  static const String systemValue = 'system';

  final LocalStorageHelper _storage = locator<LocalStorageHelper>();

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    emit(mode);
    final String value = switch (mode) {
      ThemeMode.light => lightValue,
      ThemeMode.dark => darkValue,
      ThemeMode.system => systemValue,
    };
    await _storage.saveValue(boxName, themeModeKey, value);
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }

  bool get isDarkMode => state == ThemeMode.dark;
}

Future<ThemeMode> loadInitialThemeMode() async {
  const fallback = ThemeMode.light;
  final storage = locator<LocalStorageHelper>();
  final response = await storage.getValue(
    ThemeCubit.boxName,
    ThemeCubit.themeModeKey,
  );
  return response.fold(
    (_) => fallback,
    (value) {
      final code = value?.toString();
      switch (code) {
        case ThemeCubit.darkValue:
          return ThemeMode.dark;
        case ThemeCubit.systemValue:
          return ThemeMode.system;
        case ThemeCubit.lightValue:
        default:
          return fallback;
      }
    },
  );
}
