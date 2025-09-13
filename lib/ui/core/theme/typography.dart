import 'package:flutter/material.dart';

TextTheme buildTextTheme(TextTheme base) => base.copyWith(
  headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
  titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
  bodyLarge: base.bodyLarge?.copyWith(height: 1.3),
  bodyMedium: base.bodyMedium?.copyWith(height: 1.3),
);
