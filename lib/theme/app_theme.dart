import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the voice-controlled mobile assistant application.
class AppTheme {
  AppTheme._();

  // Voice-First AI Assistant Color Palette - Intelligent Dark Theme
  static const Color primaryCyan =
      Color(0xFF00E5FF); // Cyan accent for AI orb and active states
  static const Color secondaryBlue =
      Color(0xFF1976D2); // Deep blue for secondary actions
  static const Color backgroundBlack =
      Color(0xFF0A0A0A); // True black for OLED optimization
  static const Color surfaceDark =
      Color(0xFF1A1A1A); // Dark gray for cards and elevated elements
  static const Color successGreen =
      Color(0xFF00C853); // Bright green for command confirmations
  static const Color warningAmber =
      Color(0xFFFF9800); // Amber for system alerts
  static const Color errorRed =
      Color(0xFFF44336); // Red for failures and critical issues
  static const Color textPrimary =
      Color(0xFFFFFFFF); // Pure white for maximum readability
  static const Color textSecondary =
      Color(0xFFB0BEC5); // Light gray for supporting text
  static const Color accentGlow =
      Color(0xFF00BCD4); // Teal for subtle glow effects

  // Additional semantic colors
  static const Color borderColor = Color(0xFF333333); // Minimal borders
  static const Color shadowColor =
      Color(0x4D000000); // Subtle shadows (30% opacity)
  static const Color glowShadow =
      Color(0x1A00E5FF); // Cyan glow effect (10% opacity)
  static const Color dividerColor = Color(0xFF2A2A2A); // Subtle dividers
  static const Color overlayColor =
      Color(0x80000000); // Modal overlays (50% opacity)

  // Text emphasis levels
  static const Color textHighEmphasis = Color(0xDEFFFFFF); // 87% opacity
  static const Color textMediumEmphasis = Color(0x99FFFFFF); // 60% opacity
  static const Color textDisabled = Color(0x61FFFFFF); // 38% opacity

  /// Dark theme optimized for voice-first interactions
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryCyan,
          onPrimary: backgroundBlack,
          primaryContainer: primaryCyan.withAlpha(51),
          onPrimaryContainer: textPrimary,
          secondary: secondaryBlue,
          onSecondary: textPrimary,
          secondaryContainer: secondaryBlue.withAlpha(51),
          onSecondaryContainer: textPrimary,
          tertiary: accentGlow,
          onTertiary: backgroundBlack,
          tertiaryContainer: accentGlow.withAlpha(51),
          onTertiaryContainer: textPrimary,
          error: errorRed,
          onError: textPrimary,
          errorContainer: errorRed.withAlpha(51),
          onErrorContainer: textPrimary,
          surface: surfaceDark,
          onSurface: textPrimary,
          onSurfaceVariant: textSecondary,
          outline: borderColor,
          outlineVariant: dividerColor,
          shadow: shadowColor,
          scrim: overlayColor,
          inverseSurface: textPrimary,
          onInverseSurface: backgroundBlack,
          inversePrimary: primaryCyan,
          surfaceTint: primaryCyan),
      scaffoldBackgroundColor: backgroundBlack,
      cardColor: surfaceDark,
      dividerColor: dividerColor,

      // AppBar theme for voice assistant interface
      appBarTheme: AppBarTheme(
          backgroundColor: backgroundBlack,
          foregroundColor: textPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textPrimary,
              letterSpacing: 0.5),
          iconTheme: const IconThemeData(color: primaryCyan, size: 24)),

      // Card theme for contextual information display
      cardTheme: CardTheme(
          color: surfaceDark,
          elevation: 4,
          shadowColor: shadowColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: borderColor, width: 1)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation for voice assistant controls
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceDark,
          selectedItemColor: primaryCyan,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),

      // Floating Action Button - Central AI Orb
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryCyan,
          foregroundColor: backgroundBlack,
          elevation: 8,
          focusElevation: 12,
          hoverElevation: 12,
          highlightElevation: 16,
          shape: const CircleBorder(),
          sizeConstraints:
              const BoxConstraints.tightFor(width: 72, height: 72)),

      // Button themes for voice command confirmations
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: backgroundBlack,
              backgroundColor: primaryCyan,
              disabledForegroundColor: textDisabled,
              disabledBackgroundColor: surfaceDark,
              elevation: 4,
              shadowColor: glowShadow,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryCyan,
              disabledForegroundColor: textDisabled,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: const BorderSide(color: primaryCyan, width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryCyan,
              disabledForegroundColor: textDisabled,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25))),

      // Typography for voice-first interface
      textTheme: _buildVoiceAssistantTextTheme(),

      // Input decoration for voice command text fields
      inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceDark,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: borderColor, width: 1)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: borderColor, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: primaryCyan, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: errorRed, width: 2)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: errorRed, width: 2)),
          labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 16, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textDisabled, fontSize: 16, fontWeight: FontWeight.w300),
          prefixIconColor: textSecondary,
          suffixIconColor: textSecondary),

      // Switch theme for voice settings
      switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryCyan;
            }
            return textSecondary;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryCyan.withAlpha(77);
            }
            return borderColor;
          }),
          overlayColor: WidgetStateProperty.all(primaryCyan.withAlpha(26))),

      // Checkbox theme for voice command options
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryCyan;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(backgroundBlack),
          overlayColor: WidgetStateProperty.all(primaryCyan.withAlpha(26)),
          side: const BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),

      // Radio theme for voice assistant options
      radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryCyan;
            }
            return borderColor;
          }),
          overlayColor: WidgetStateProperty.all(primaryCyan.withAlpha(26))),

      // Progress indicators for voice processing
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryCyan, linearTrackColor: borderColor, circularTrackColor: borderColor),

      // Slider theme for voice sensitivity controls
      sliderTheme: SliderThemeData(activeTrackColor: primaryCyan, thumbColor: primaryCyan, overlayColor: primaryCyan.withAlpha(51), inactiveTrackColor: borderColor, valueIndicatorColor: primaryCyan, valueIndicatorTextStyle: GoogleFonts.jetBrainsMono(color: backgroundBlack, fontSize: 14, fontWeight: FontWeight.w500)),

      // Tab bar theme for voice assistant sections
      tabBarTheme: TabBarTheme(labelColor: primaryCyan, unselectedLabelColor: textSecondary, indicatorColor: primaryCyan, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25)),

      // Tooltip theme for voice command help
      tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(color: surfaceDark, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor), boxShadow: [
            BoxShadow(
                color: shadowColor, blurRadius: 8, offset: const Offset(0, 4)),
          ]),
          textStyle: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w400),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),

      // Snackbar theme for voice command feedback
      snackBarTheme: SnackBarThemeData(backgroundColor: surfaceDark, contentTextStyle: GoogleFonts.inter(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: primaryCyan, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: const BorderSide(color: borderColor)), elevation: 8),

      // Dialog theme for voice confirmations
      dialogTheme: DialogTheme(backgroundColor: surfaceDark, surfaceTintColor: Colors.transparent, elevation: 16, shadowColor: shadowColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0), side: const BorderSide(color: borderColor)), titleTextStyle: GoogleFonts.orbitron(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.5), contentTextStyle: GoogleFonts.inter(color: textSecondary, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.25)),

      // Bottom sheet theme for contextual voice options
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: surfaceDark, surfaceTintColor: Colors.transparent, elevation: 16, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.0))), showDragHandle: true, dragHandleColor: borderColor, dragHandleSize: Size(40, 4)),

      // List tile theme for voice command history
      listTileTheme: ListTileThemeData(tileColor: Colors.transparent, selectedTileColor: primaryCyan.withAlpha(26), iconColor: textSecondary, selectedColor: primaryCyan, textColor: textPrimary, titleTextStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15), subtitleTextStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w300, letterSpacing: 0.25), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),

      // Chip theme for voice command tags
      chipTheme: ChipThemeData(backgroundColor: surfaceDark, selectedColor: primaryCyan.withAlpha(51), disabledColor: borderColor, deleteIconColor: textSecondary, labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4), secondaryLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: borderColor)), elevation: 2, shadowColor: shadowColor));

  /// Light theme (minimal implementation for accessibility)
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: secondaryBlue,
          onPrimary: Colors.white,
          primaryContainer: secondaryBlue.withAlpha(26),
          onPrimaryContainer: secondaryBlue,
          secondary: primaryCyan,
          onSecondary: Colors.black,
          secondaryContainer: primaryCyan.withAlpha(26),
          onSecondaryContainer: secondaryBlue,
          tertiary: accentGlow,
          onTertiary: Colors.white,
          tertiaryContainer: accentGlow.withAlpha(26),
          onTertiaryContainer: secondaryBlue,
          error: errorRed,
          onError: Colors.white,
          errorContainer: errorRed.withAlpha(26),
          onErrorContainer: errorRed,
          surface: Colors.white,
          onSurface: Colors.black87,
          onSurfaceVariant: Colors.black54,
          outline: Colors.grey.shade400,
          outlineVariant: Colors.grey.shade300,
          shadow: Colors.black26,
          scrim: Colors.black54,
          inverseSurface: Colors.grey.shade800,
          onInverseSurface: Colors.white,
          inversePrimary: primaryCyan,
          surfaceTint: secondaryBlue),
      scaffoldBackgroundColor: Colors.grey.shade50,
      textTheme: _buildVoiceAssistantTextTheme(isLight: true));

  /// Helper method to build voice assistant optimized text theme
  static TextTheme _buildVoiceAssistantTextTheme({bool isLight = false}) {
    final Color textColor = isLight ? Colors.black87 : textPrimary;
    final Color textColorMedium = isLight ? Colors.black54 : textSecondary;
    final Color textColorDisabled = isLight ? Colors.black38 : textDisabled;

    return TextTheme(
        // Display styles - Orbitron for futuristic headings
        displayLarge: GoogleFonts.orbitron(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: -0.25,
            height: 1.12),
        displayMedium: GoogleFonts.orbitron(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: 0,
            height: 1.16),
        displaySmall: GoogleFonts.orbitron(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: textColor,
            letterSpacing: 0,
            height: 1.22),

        // Headline styles - Orbitron for section headers
        headlineLarge: GoogleFonts.orbitron(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: 0,
            height: 1.25),
        headlineMedium: GoogleFonts.orbitron(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: textColor,
            letterSpacing: 0,
            height: 1.29),
        headlineSmall: GoogleFonts.orbitron(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: textColor,
            letterSpacing: 0,
            height: 1.33),

        // Title styles - Inter for interface elements
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textColor,
            letterSpacing: 0,
            height: 1.27),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
            letterSpacing: 0.15,
            height: 1.50),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
            letterSpacing: 0.1,
            height: 1.43),

        // Body styles - Inter for readable content
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
            letterSpacing: 0.5,
            height: 1.50),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textColor,
            letterSpacing: 0.25,
            height: 1.43),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textColorMedium,
            letterSpacing: 0.4,
            height: 1.33),

        // Label styles - Roboto for system elements
        labelLarge: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
            letterSpacing: 0.1,
            height: 1.43),
        labelMedium: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColorMedium,
            letterSpacing: 0.5,
            height: 1.33),
        labelSmall: GoogleFonts.roboto(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textColorDisabled,
            letterSpacing: 0.5,
            height: 1.45));
  }

  /// Custom text styles for specific voice assistant elements
  static TextStyle get dataDisplayStyle => GoogleFonts.jetBrainsMono(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: primaryCyan,
      letterSpacing: 0.5,
      height: 1.4);

  static TextStyle get commandHistoryStyle => GoogleFonts.jetBrainsMono(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: textSecondary,
      letterSpacing: 0.25,
      height: 1.5);

  static TextStyle get systemMetricsStyle => GoogleFonts.jetBrainsMono(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: accentGlow,
      letterSpacing: 0.5,
      height: 1.6);

  /// Custom box decorations for voice assistant UI elements
  static BoxDecoration get aiOrbDecoration => BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [
            primaryCyan.withAlpha(204),
            primaryCyan.withAlpha(102),
            primaryCyan.withAlpha(26),
          ], stops: const [
            0.0,
            0.7,
            1.0
          ]),
          boxShadow: [
            BoxShadow(
                color: primaryCyan.withAlpha(77),
                blurRadius: 20,
                spreadRadius: 5),
            BoxShadow(
                color: primaryCyan.withAlpha(26),
                blurRadius: 40,
                spreadRadius: 10),
          ]);

  static BoxDecoration get glassCardDecoration => BoxDecoration(
          color: surfaceDark.withAlpha(204),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
                color: shadowColor, blurRadius: 8, offset: const Offset(0, 4)),
            BoxShadow(
                color: accentGlow.withAlpha(13),
                blurRadius: 16,
                offset: const Offset(0, 8)),
          ]);

  static BoxDecoration get waveformDecoration => BoxDecoration(
          color: backgroundBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryCyan.withAlpha(77), width: 1),
          boxShadow: [
            BoxShadow(
                color: primaryCyan.withAlpha(26),
                blurRadius: 12,
                spreadRadius: 2),
          ]);
}
