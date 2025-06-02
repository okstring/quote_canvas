import 'package:flutter/material.dart';
import 'package:quote_canvas/ui/app_colors.dart';

import 'app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.navy100,
        secondary: AppColors.navy40,
        surface: AppColors.white,
        error: AppColors.warning,
      ),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        shadowColor: AppColors.richBlack,
        iconTheme: IconThemeData(color: AppColors.richBlack),
        titleTextStyle: TextStyle(
          color: AppColors.richBlack,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Pretendard',
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.navy40,
        secondary: AppColors.navy20,
        surface: AppColors.richBlack,
        error: AppColors.warning,
      ),
      scaffoldBackgroundColor: AppColors.backgroundBlack,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.blackBar,
        elevation: 0.5,
        shadowColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: AppTextStyles.header(color: AppColors.white),
      ),
      textTheme: TextTheme(
        titleLarge: AppTextStyles.header(color: AppColors.white),
      ),
      cardTheme: CardThemeData(
        color: AppColors.gray1,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
