import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_tokens.dart';

ThemeData buildMaterialTheme(AppThemeTokens t) {
  final isDark = t.bg.computeLuminance() < 0.3;
  final base = isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true);

  TextTheme textTheme() {
    try {
      return GoogleFonts.getTextTheme(t.bodyFont, base.textTheme).apply(
        bodyColor: t.text,
        displayColor: t.text,
      );
    } catch (_) {
      return base.textTheme.apply(bodyColor: t.text, displayColor: t.text);
    }
  }

  return base.copyWith(
    scaffoldBackgroundColor: t.bg,
    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: t.accent,
      onPrimary: t.textOnDark,
      secondary: t.gold,
      onSecondary: t.onGold,
      surface: t.surface,
      onSurface: t.text,
      error: Colors.red,
      onError: Colors.white,
    ),
    textTheme: textTheme(),
    cardTheme: CardThemeData(
      color: t.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(t.shape.cardRadius),
        side: BorderSide(color: t.surfaceBorder, width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: t.bg,
      foregroundColor: t.textOnDark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: t.accent,
      foregroundColor: t.textOnDark,
    ),
    dividerTheme: DividerThemeData(color: t.surfaceBorder, thickness: 1),
    chipTheme: ChipThemeData(
      backgroundColor: t.surfaceAlt,
      selectedColor: t.accent,
      labelStyle: TextStyle(color: t.text, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
  );
}
