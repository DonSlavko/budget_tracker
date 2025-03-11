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

  // Background Colors
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color inputFillColor = Color(0xFFF1F5F9);  // Light Gray for inputs
  static const Color cardColor = Colors.white;

  // Text Colors
  static const Color primaryTextColor = Color(0xFF1E293B);
  static const Color secondaryTextColor = Color(0xFF64748B);
  static const Color accentTextColor = Color(0xFF2196F3);

  // Status Colors
  static const Color successColor = Color(0xFF22C55E);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // Border Colors
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color dividerColor = Color(0xFFE2E8F0);

  // Custom Text Styles with Google Fonts
  static TextStyle get headingStyle => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryTextColor,
    height: 1.2,
  );

  static TextStyle get subheadingStyle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryTextColor,
    height: 1.3,
  );

  static TextStyle get bodyStyle => GoogleFonts.inter(
    fontSize: 16,
    color: primaryTextColor,
    height: 1.5,
  );

  static TextStyle get captionStyle => GoogleFonts.inter(
    fontSize: 14,
    color: secondaryTextColor,
    height: 1.4,
  );

  // Custom Component Themes
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    ),
    textTheme: GoogleFonts.interTextTheme(),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: primaryTextColor),
      titleTextStyle: GoogleFonts.inter(
        color: primaryTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputFillColor,
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
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      labelStyle: GoogleFonts.inter(color: secondaryTextColor),
      hintStyle: GoogleFonts.inter(color: secondaryTextColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              return Colors.white;
            }
            return Colors.transparent;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.black87;
            }
            return Colors.black54;
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryTextColor,
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
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 24,
    ),
  );
} 