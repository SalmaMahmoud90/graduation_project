import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/app_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData _theme(String fontFamily) => ThemeData(
    scaffoldBackgroundColor: AppColors.backGround,
    appBarTheme: _appBarTheme,
    fontFamily: fontFamily,
    textTheme: _textTheme(fontFamily),
    inputDecorationTheme: _inputDecorationTheme(fontFamily),
    useMaterial3: true,
  );

  static ThemeData lightTheme(String languageCode) => _theme(_resolveFontFamily(languageCode)).copyWith();

  static ThemeData darkTheme(String languageCode) => _theme(_resolveFontFamily(languageCode)).copyWith();

  static String _resolveFontFamily(String languageCode) =>
      languageCode == 'ar' ? AppFontFamily.tajawal : AppFontFamily.cairo;

  static AppBarTheme get _appBarTheme => const AppBarTheme(
    elevation: 0.0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.backGround,
  );

  static InputDecorationTheme _inputDecorationTheme(String fontFamily) => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.backGround,
    errorStyle: TextStyle(
      color: AppColors.red,
      fontSize: 15,
      fontFamily: fontFamily,
      fontWeight: AppFontWeight.medium,
    ),
    // border: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(AppRadius.r7),
    //   borderSide: const BorderSide(color: AppColors.red, width: 1),
    // ),
    // enabledBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(AppRadius.r7),
    //   borderSide: const BorderSide(color: AppColors.grey, width: 1),
    // ),
    // focusedBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(AppRadius.r7),
    //   borderSide: const BorderSide(color: AppColors.primary, width: 1),
    // ),
    // errorBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(AppRadius.r7),
    //   borderSide: const BorderSide(color: AppColors.red, width: 1),
    // ),
  );

  static TextTheme _textTheme(String fontFamily) => TextTheme(
    titleLarge: titleLarge(fontFamily),
    titleMedium: titleMedium(fontFamily),
    titleSmall: titleSmall(fontFamily),
    bodyLarge: bodyLarge(fontFamily),
    bodyMedium: bodyMedium(fontFamily),
    bodySmall: bodySmall(fontFamily),
  );

  static TextStyle titleLarge(String fontFamily) => TextStyle(
    fontFamily: fontFamily,

  );

  static TextStyle titleMedium(String fontFamily) => TextStyle(
    fontFamily: fontFamily,
  );

  static TextStyle titleSmall(String fontFamily) => TextStyle(
    fontFamily: fontFamily,
  );

  static TextStyle bodyLarge(String fontFamily) => TextStyle(
    fontFamily: fontFamily,
  );

  static TextStyle bodyMedium(String fontFamily) => TextStyle(
    fontFamily: fontFamily,

  );

  static TextStyle bodySmall(String fontFamily) => TextStyle(
    fontFamily: fontFamily,
  );
}
