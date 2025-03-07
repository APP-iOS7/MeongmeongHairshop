import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/config/app_styles.dart';

ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.textDark,
    // 색상 테마
    colorScheme: ColorScheme.light(
      primary: AppColors.textDark,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.cardBackground,
    // 텍스트 테마
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1.copyWith(color: AppColors.textDark),
      displayMedium: AppTextStyles.heading2.copyWith(color: AppColors.textDark),
      displaySmall: AppTextStyles.heading3.copyWith(color: AppColors.textDark),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDark),
      bodyMedium: AppTextStyles.heading4.copyWith(color: AppColors.textDark),
      labelMedium: AppTextStyles.bodyBord.copyWith(color: AppColors.textMedium),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textMedium),
      labelLarge: AppTextStyles.button.copyWith(color: Colors.white),
    ),
    // 앱바 테마
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cardBackground,
      elevation: 0,
      titleTextStyle: AppTextStyles.bodyBord.copyWith(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    // 카드 테마
    cardTheme: CardTheme(
      color: AppColors.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textDark,
        textStyle: AppTextStyles.button,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // 입력 필드 테마
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(fontSize: 14, color: AppColors.textMedium),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.textLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.textMedium, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
