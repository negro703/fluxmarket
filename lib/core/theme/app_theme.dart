import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A central theme configuration for the FluxMarket application.
/// Provides a modern, sleek aesthetic with an Indigo primary color scheme
/// and the Poppins font family.
class AppTheme {
  // ── Private constructor ──────────────────────────────────────────────
  AppTheme._();

  // ── Consistent Spacing & Size Constants ───────────────────────────────
  /// Standard horizontal page padding.
  static const double pageHorizontalPadding = 16.0;

  /// Standard vertical page padding.
  static const double pageVerticalPadding = 16.0;

  /// Standard spacing between elements (xs).
  static const double spacingXs = 4.0;

  /// Standard spacing between elements (sm).
  static const double spacingSm = 8.0;

  /// Standard spacing between elements (md).
  static const double spacingMd = 12.0;

  /// Standard spacing between elements (lg).
  static const double spacingLg = 16.0;

  /// Standard spacing between elements (xl).
  static const double spacingXl = 24.0;

  /// Standard spacing between elements (2xl).
  static const double spacing2xl = 32.0;

  /// Standard card border radius.
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 20.0;

  /// Button dimensions.
  static const double buttonHeight = 48.0;
  static const double iconButtonSize = 40.0;

  /// Grid configuration for responsive layouts.
  static const int gridColumnsMobile = 2;
  static const int gridColumnsTablet = 3;
  static const int gridColumnsDesktop = 4;
  static const double gridChildAspectRatio = 0.65;
  static const double gridSpacing = 12.0;

  // ── Color Palette ────────────────────────────────────────────────────
  static const Color _primaryColor = Color(0xFF4F46E5); // Indigo-600
  static const Color _primaryLight = Color(0xFF818CF8); // Indigo-400
  static const Color _secondaryColor = Color(0xFF06B6D4); // Cyan-500
  static const Color _errorColor = Color(0xFFEF4444); // Red-500
  static const Color _surfaceColor = Color(0xFFF8FAFC); // Slate-50
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color _textSecondary = Color(0xFF475569); // Slate-600
  static const Color _textHint = Color(0xFF94A3B8); // Slate-400
  static const Color _dividerColor = Color(0xFFE2E8F0); // Slate-200

  // ── Light Theme ──────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.poppinsTextTheme(
      ThemeData.light().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
        primary: _primaryColor,
        onPrimary: Colors.white,
        secondary: _secondaryColor,
        error: _errorColor,
        surface: _surfaceColor,
      ),

      // ── Text Theme ──
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: _textPrimary,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
          color: _textPrimary,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: _textPrimary,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
          color: _textSecondary,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: _textSecondary,
        ),
        labelSmall: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
          color: _textHint,
        ),
      ),

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: _backgroundColor,
        foregroundColor: _textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
      ),

      // ── Elevated Button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: _primaryColor,
          disabledForegroundColor: _textHint,
          disabledBackgroundColor: _dividerColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Outlined Button ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Text Button ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ── Input Decoration ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _textSecondary,
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _textHint,
        ),
        errorStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _errorColor,
        ),
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _dividerColor, width: 1),
        ),
        color: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ── Chip ──
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: _dividerColor),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // ── Bottom Navigation Bar ──
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: _backgroundColor,
        selectedItemColor: _primaryColor,
        unselectedItemColor: _textHint,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── Divider ──
      dividerTheme: DividerThemeData(
        color: _dividerColor,
        thickness: 1,
        space: 1,
      ),

      // ── Snackbar ──
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),

      // ── Bottom Sheet ──
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // ── Floating Action Button ──
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ── Progress Indicator ──
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryColor,
        linearTrackColor: _primaryLight,
      ),

      // ── Scaffold ──
      scaffoldBackgroundColor: _backgroundColor,
    );
  }

  // ── Dark Theme ───────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
        primary: _primaryLight,
        onPrimary: Colors.black,
        secondary: _secondaryColor,
        error: _errorColor,
        surface: const Color(0xFF1E293B), // Slate-800
      ),

      // ── Text Theme ──
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
          color: const Color(0xFF94A3B8),
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: const Color(0xFF94A3B8),
        ),
        labelSmall: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
          color: const Color(0xFF64748B),
        ),
      ),

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // ── Elevated Button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: _primaryLight,
          disabledForegroundColor: const Color(0xFF64748B),
          disabledBackgroundColor: const Color(0xFF1E293B),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF334155), width: 1),
        ),
        color: const Color(0xFF1E293B),
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ── Scaffold ──
      scaffoldBackgroundColor: const Color(0xFF0F172A),
    );
  }
}