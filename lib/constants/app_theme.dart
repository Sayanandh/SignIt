import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF6A5AE0);
  static const Color primaryLightColor = Color(0xFF8A7EE6);
  static const Color primaryDarkColor = Color(0xFF4A3AD0);
  
  // Secondary colors
  static const Color secondaryColor = Color(0xFF00C2CB);
  static const Color secondaryLightColor = Color(0xFF4FDFE5);
  static const Color secondaryDarkColor = Color(0xFF00A5AD);
  
  // Accent colors
  static const Color accentColor = Color(0xFFFF8A65);
  
  // Background colors
  static const Color backgroundColor = Color(0xFFF8F9FE);
  static const Color cardColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF0F3FA);
  
  // Text colors
  static const Color textPrimaryColor = Color(0xFF2D3142);
  static const Color textSecondaryColor = Color(0xFF7C7E92);
  static const Color textLightColor = Color(0xFFADAFC8);
  
  // Status colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFFB74D);
  static const Color infoColor = Color(0xFF2196F3);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: AppColors.surfaceColor,
      background: AppColors.backgroundColor,
      error: AppColors.errorColor,
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    cardTheme: const CardTheme(
      color: AppColors.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.textPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryColor,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        color: AppColors.textPrimaryColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        color: AppColors.textPrimaryColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        color: AppColors.textPrimaryColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: AppColors.textPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: AppColors.textPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.poppins(
        color: AppColors.textPrimaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: AppColors.textPrimaryColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: AppColors.textSecondaryColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.poppins(
        color: AppColors.textLightColor,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
      ),
      hintStyle: GoogleFonts.poppins(
        color: AppColors.textLightColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
} 