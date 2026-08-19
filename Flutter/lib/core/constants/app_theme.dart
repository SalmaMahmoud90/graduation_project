import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/app_fonts.dart';

class AppTheme {
  AppTheme._();

  static String _resolveFontFamily(String languageCode) =>
      languageCode == 'ar' ? AppFontFamily.tajawal : AppFontFamily.cairo;

  static ThemeData lightTheme(String languageCode) {
    final fontFamily = _resolveFontFamily(languageCode);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.backGround,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.white,
        error: AppColors.red,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.blackText,
        onError: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backGround,
        foregroundColor: AppColors.blackText,
        surfaceTintColor: Colors.transparent,
      ),
      cardColor: AppColors.white,
      dividerColor: AppColors.greyDivider,
      hintColor: AppColors.greyText,
      textTheme: _buildTextTheme(fontFamily, Brightness.light),
      inputDecorationTheme: _buildInputDecorationTheme(fontFamily, Brightness.light),
      iconTheme: const IconThemeData(color: AppColors.blackText),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData darkTheme(String languageCode) {
    final fontFamily = _resolveFontFamily(languageCode);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkAccent,
        surface: AppColors.darkSurface,
        error: AppColors.darkError,
        onPrimary: AppColors.darkBackground,
        onSecondary: AppColors.darkBackground,
        onSurface: AppColors.darkTextPrimary,
        onError: AppColors.darkBackground,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.darkAppBar,
        foregroundColor: AppColors.darkTextPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkDivider,
      hintColor: AppColors.darkTextHint,
      textTheme: _buildTextTheme(fontFamily, Brightness.dark),
      inputDecorationTheme: _buildInputDecorationTheme(fontFamily, Brightness.dark),
      iconTheme: const IconThemeData(color: AppColors.darkIcon),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(String fontFamily, Brightness brightness) {
    final textColor = brightness == Brightness.light
        ? AppColors.blackText
        : AppColors.darkTextPrimary;
    final secondaryTextColor = brightness == Brightness.light
        ? AppColors.greyText
        : AppColors.darkTextSecondary;

    return TextTheme(
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        color: textColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        color: textColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        color: secondaryTextColor,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        color: secondaryTextColor,
        fontSize: 12,
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(String fontFamily, Brightness brightness) {
    final errorColor = brightness == Brightness.light ? AppColors.red : AppColors.darkError;
    final fillColor = brightness == Brightness.light ? AppColors.white : AppColors.darkCard;
    final hintColor = brightness == Brightness.light ? AppColors.greyText : AppColors.darkTextHint;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: TextStyle(color: hintColor, fontFamily: fontFamily),
      errorStyle: TextStyle(
        color: errorColor,
        fontSize: 13,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: brightness == Brightness.light ? AppColors.greyDivider : AppColors.darkDivider,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: brightness == Brightness.light ? AppColors.greyDivider : AppColors.darkDivider,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: brightness == Brightness.light ? AppColors.primary : AppColors.darkPrimary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorColor),
      ),
    );
  }
}
