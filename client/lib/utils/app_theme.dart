import 'package:dartopia/consts/calors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData dartopiaTheme = _buildDartopiaTheme();

IconThemeData _customIconTheme(IconThemeData original, Color color) {
  return original.copyWith(color: color);
}

ThemeData _buildDartopiaTheme() {
  final base = ThemeData.light();

  return base.copyWith(
    //useMaterial3: true,
    colorScheme: const ColorScheme.light().copyWith(
      primary: DartopiaColors.primary,
      secondary: DartopiaColors.background,
      error: DartopiaColors.error,
    ),

    hintColor: DartopiaColors.background2,
    indicatorColor: DartopiaColors.primary,
    scaffoldBackgroundColor: DartopiaColors.background,
    cardColor: DartopiaColors.surface,
    highlightColor: Colors.transparent,
    textTheme: _buildDartopiaTextTheme(base.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: DartopiaColors.primaryContainer,
    ),
    primaryTextTheme: _buildDartopiaTextTheme(base.primaryTextTheme),
    iconTheme: _customIconTheme(base.iconTheme, DartopiaColors.primary),
    primaryIconTheme: _customIconTheme(base.iconTheme, DartopiaColors.primary),
  );
}

TextTheme _buildDartopiaTextTheme(TextTheme base) {
  return GoogleFonts.boogalooTextTheme();
}
