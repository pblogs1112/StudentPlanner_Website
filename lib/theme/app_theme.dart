import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Step C — Spacing as Constants
class AppSpacing {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

/// Step A/B/E — ColorScheme + TextTheme, assembled
class AppTheme {
  static const _ink = Color(0xFF1E1E1E);

  static const _scheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2563EB),
    onPrimary: Colors.white,
    secondary: Color(0xFF0C2FB8),
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: _ink,
    error: Color(0xFFDC2626),
    onError: Colors.white,
    tertiary: Color(0xFF4ADE80), // success
    onTertiary: _ink, // onSuccess
    primaryContainer: Color(0xFF7DA3F5), // Pending badge bg
    onPrimaryContainer: Color(0xFF052B80), // Pending badge text
    secondaryContainer: Color(0xFF7AA0F4), // subject pills
    onSecondaryContainer: Color(0xFF052B80), // subject pill text
    surfaceContainerHighest: Color(0xFFDCE4FA), // class/task/note/event cards
  );

  static TextStyle _t(double size, FontWeight w) =>
      TextStyle(fontSize: size, fontWeight: w, color: _ink);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _scheme,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        headlineSmall: _t(24, FontWeight.bold), // Heading
        bodyMedium: _t(16, FontWeight.normal), // Body
        labelSmall: _t(12, FontWeight.normal), // Caption
        labelLarge: _t(14, FontWeight.bold), // Button
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _scheme.primary,
      foregroundColor: _scheme.onPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _scheme.secondary,
        foregroundColor: _scheme.onSecondary,
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    chipTheme: ChipThemeData(
      selectedColor: _scheme.primary,
      showCheckmark: false,
      secondaryLabelStyle: TextStyle(color: _scheme.onPrimary),
    ),
  );
}
