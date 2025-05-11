import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,

  // 프로그레스 바 (로딩바)
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearMinHeight: 3,
    circularTrackColor: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  textTheme: const TextTheme(
      // bodyLarge: TextStyle(fontSize: 18.0, color: AppColors.text),
      // bodyMedium: TextStyle(fontSize: 16.0, color: AppColors.textSecondary),
      ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        disabledBackgroundColor: AppColors.labelAssistive,
        minimumSize: Size(double.infinity, 0),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        textStyle: title_L,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 12),
        shadowColor: Colors.transparent,
        elevation: 0),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.background,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
  ),
);
