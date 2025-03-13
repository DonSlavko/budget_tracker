import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF2196F3);  // Blue
  static const Color primaryLightColor = Color(0xFFE3F2FD);  // Light Blue
  static const Color primaryDarkColor = Color(0xFF1976D2);

  // Secondary Colors
  static const Color secondaryColor = Color(0xFF0F172A);  // Slate Dark
  static const Color secondaryLightColor = Color(0xFF334155);
  static const Color secondaryDarkColor = Color(0xFF0F172A);

  // Light Theme Colors
  static const Color lightBackgroundColor = Color(0xFFF8FAFC);
  static const Color lightSurfaceColor = Colors.white;
  static const Color lightInputFillColor = Color(0xFFF1F5F9);
  static const Color lightCardColor = Colors.white;
  static const Color lightPrimaryTextColor = Color(0xFF1E293B);
  static const Color lightSecondaryTextColor = Color(0xFF64748B);
  static const Color lightBorderColor = Color(0xFFE2E8F0);

  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF1A1A1A);
  static const Color darkSurfaceColor = Color(0xFF2D2D2D);
  static const Color darkInputFillColor = Color(0xFF3D3D3D);
  static const Color darkCardColor = Color(0xFF2D2D2D);
  static const Color darkPrimaryTextColor = Color(0xFFE5E5E5);
  static const Color darkSecondaryTextColor = Color(0xFFA3A3A3);
  static const Color darkBorderColor = Color(0xFF404040);

  // Light Theme Colors
  static const Color backgroundColor = lightBackgroundColor;
  static const Color surfaceColor = lightSurfaceColor;
  static const Color inputFillColor = lightInputFillColor;
  static const Color cardColor = lightCardColor;
  static const Color primaryTextColor = lightPrimaryTextColor;
  static const Color secondaryTextColor = lightSecondaryTextColor;
  static const Color borderColor = lightBorderColor;

  // Status Colors (same for both themes)
  static const Color successColor = Color(0xFF22C55E);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // Custom Text Styles with Google Fonts
  static TextStyle get headingStyle => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get subheadingStyle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get bodyStyle => GoogleFonts.inter(
    fontSize: 16,
    height: 1.5,
  );

  static TextStyle get captionStyle => GoogleFonts.inter(
    fontSize: 14,
    height: 1.4,
  );

  // Theme Data
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: lightBackgroundColor,
      surface: lightSurfaceColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: lightPrimaryTextColor,
      onSurface: lightPrimaryTextColor,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: headingStyle.copyWith(color: lightPrimaryTextColor),
      headlineMedium: headingStyle.copyWith(color: lightPrimaryTextColor),
      titleLarge: subheadingStyle.copyWith(color: lightPrimaryTextColor),
      bodyLarge: bodyStyle.copyWith(color: lightPrimaryTextColor),
      bodyMedium: bodyStyle.copyWith(color: lightPrimaryTextColor),
      bodySmall: captionStyle.copyWith(color: lightSecondaryTextColor),
    ),
    scaffoldBackgroundColor: lightBackgroundColor,
    cardColor: lightCardColor,
    dividerColor: lightBorderColor,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightInputFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardTheme(
      color: lightSurfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: lightBorderColor),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightSurfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(color: lightPrimaryTextColor),
      titleTextStyle: headingStyle.copyWith(color: lightPrimaryTextColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightSurfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: lightSecondaryTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: const CircleBorder(),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primaryLightColor,
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return lightCardColor;
            }
            return Colors.transparent;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return lightPrimaryTextColor;
            }
            return lightSecondaryTextColor;
          },
        ),
        side: MaterialStateProperty.all(BorderSide.none),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 14),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(
          const Size(0, 48),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: darkBackgroundColor,
      surface: darkSurfaceColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: darkPrimaryTextColor,
      onSurface: darkPrimaryTextColor,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: headingStyle.copyWith(color: darkPrimaryTextColor),
      headlineMedium: headingStyle.copyWith(color: darkPrimaryTextColor),
      titleLarge: subheadingStyle.copyWith(color: darkPrimaryTextColor),
      bodyLarge: bodyStyle.copyWith(color: darkPrimaryTextColor),
      bodyMedium: bodyStyle.copyWith(color: darkPrimaryTextColor),
      bodySmall: captionStyle.copyWith(color: darkSecondaryTextColor),
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    dividerColor: darkBorderColor,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkInputFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardTheme(
      color: darkSurfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: darkBorderColor),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(color: darkPrimaryTextColor),
      titleTextStyle: headingStyle.copyWith(color: darkPrimaryTextColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkSurfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: darkSecondaryTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: const CircleBorder(),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primaryLightColor.withOpacity(0.1),
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return darkSurfaceColor;
            }
            return Colors.transparent;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return darkPrimaryTextColor;
            }
            return darkSecondaryTextColor;
          },
        ),
        side: MaterialStateProperty.all(BorderSide.none),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 14),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(
          const Size(0, 48),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
} 