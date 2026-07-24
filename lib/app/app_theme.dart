import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => _lightThemeData;

  static ThemeData get darkTheme => _darkThemeData;

  static final ThemeData _lightThemeData = ThemeData(
    colorSchemeSeed: AppColors.themeColor,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.themeColor,
    ),
    scaffoldBackgroundColor: AppColors.lightScaffoldBackground,
    cardColor: AppColors.lightCardBackground,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.lightPrimaryText,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.lightPrimaryText,
      ),
      labelLarge: TextStyle(
        color: AppColors.lightSecondaryText,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: _inputDecorationTheme,
    filledButtonTheme: _filledButtonTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightScaffoldBackground,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: AppColors.lightPrimaryText,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final ThemeData _darkThemeData = ThemeData(
    colorSchemeSeed: AppColors.themeColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkScaffoldBackground,
    cardColor: AppColors.darkCardBackground,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.themeColor,
    ),
    inputDecorationTheme: _inputDecorationTheme,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.darkPrimaryText,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.darkPrimaryText,
      ),
      labelLarge: TextStyle(
        color: AppColors.darkSecondaryText,
        fontWeight: FontWeight.w400,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkScaffoldBackground,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: AppColors.darkPrimaryText,
        fontWeight: FontWeight.w600,
      ),
    ),
    filledButtonTheme: _filledButtonTheme,
  );

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        contentPadding: .only(left: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.themeColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.themeColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.themeColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      );

  static final FilledButtonThemeData _filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.themeColor,
      fixedSize: Size.fromWidth(double.maxFinite),
      shape: RoundedRectangleBorder(borderRadius: .circular(8)),
    ),
  );
}
