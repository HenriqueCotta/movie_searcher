import 'package:flutter/material.dart';
import 'package:movie_searcher/ui/core/theme/palette.dart';
import 'package:movie_searcher/ui/core/theme/typography.dart';

ThemeData _buildTheme(Brightness brightness) {
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  return base.copyWith(
    textTheme: buildTextTheme(base.textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: base.colorScheme.surface,
      foregroundColor: base.colorScheme.onSurface,
    ),
    cardTheme: const CardThemeData(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: base.colorScheme.surfaceContainerHighest, // ok no light/dark
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: base.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: base.colorScheme.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      labelStyle: TextStyle(color: base.colorScheme.onSurfaceVariant),
    ),
  );
}

ThemeData buildLightTheme() => _buildTheme(Brightness.light);
ThemeData buildDarkTheme() => _buildTheme(Brightness.dark);
