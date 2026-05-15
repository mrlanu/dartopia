import 'package:dartopia/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Base theme; prefer [scaledDartopiaTheme] inside [ScreenUtilInit].
final ThemeData dartopiaTheme = _buildDartopiaTheme();

ThemeData get scaledDartopiaTheme => _buildDartopiaTheme(scaleText: true);

IconThemeData _customIconTheme(IconThemeData original, Color color) {
  return original.copyWith(color: color);
}

ThemeData _buildDartopiaTheme({bool scaleText = false}) {
  final base = ThemeData.light();
  final textTheme = _buildDartopiaTextTheme(base.textTheme, scaleText: scaleText);

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
    textTheme: textTheme,
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: DartopiaColors.primaryContainer,
    ),
    primaryTextTheme: textTheme,
    iconTheme: _customIconTheme(base.iconTheme, DartopiaColors.primary),
    primaryIconTheme: _customIconTheme(base.iconTheme, DartopiaColors.primary),
  );
}

TextTheme _buildDartopiaTextTheme(TextTheme base, {bool scaleText = false}) {
  // Avoid package:google_fonts here: it reads AssetManifest, which newer Flutter
  // builds no longer ship as AssetManifest.json (breaks at runtime).
  if (!scaleText) {
    return base;
  }

  double? sp(double? size) => size?.sp;

  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontSize: sp(base.displayLarge!.fontSize)),
    displayMedium: base.displayMedium?.copyWith(fontSize: sp(base.displayMedium!.fontSize)),
    displaySmall: base.displaySmall?.copyWith(fontSize: sp(base.displaySmall!.fontSize)),
    headlineLarge: base.headlineLarge?.copyWith(fontSize: sp(base.headlineLarge!.fontSize)),
    headlineMedium: base.headlineMedium?.copyWith(fontSize: sp(base.headlineMedium!.fontSize)),
    headlineSmall: base.headlineSmall?.copyWith(fontSize: sp(base.headlineSmall!.fontSize)),
    titleLarge: base.titleLarge?.copyWith(fontSize: sp(base.titleLarge!.fontSize)),
    titleMedium: base.titleMedium?.copyWith(fontSize: sp(base.titleMedium!.fontSize)),
    titleSmall: base.titleSmall?.copyWith(fontSize: sp(base.titleSmall!.fontSize)),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: sp(base.bodyLarge!.fontSize)),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: sp(base.bodyMedium!.fontSize)),
    bodySmall: base.bodySmall?.copyWith(fontSize: sp(base.bodySmall!.fontSize)),
    labelLarge: base.labelLarge?.copyWith(fontSize: sp(base.labelLarge!.fontSize)),
    labelMedium: base.labelMedium?.copyWith(fontSize: sp(base.labelMedium!.fontSize)),
    labelSmall: base.labelSmall?.copyWith(fontSize: sp(base.labelSmall!.fontSize)),
  );
}
