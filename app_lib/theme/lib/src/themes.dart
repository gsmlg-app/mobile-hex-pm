import 'package:app_theme/src/color_schemes/fire.dart' as fire;
import 'package:app_theme/src/color_schemes/green.dart' as green;
import 'package:app_theme/src/color_schemes/violet.dart' as violet;
import 'package:app_theme/src/color_schemes/wheat.dart' as wheat;
import 'package:flutter/material.dart';

// import 'package:app_theme/src/typography.dart';

final themeList = [VioletTheme(), GreenTheme(), FireTheme(), WheatTheme()];

ThemeData _buildTheme(ColorScheme colorScheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: colorScheme.surfaceTint,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.primary,
      textColor: colorScheme.onSurface,
      subtitleTextStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide.none,
      backgroundColor: colorScheme.secondaryContainer,
      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
      secondaryLabelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      space: 24,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

abstract class AppTheme {
  const AppTheme({
    required this.name,
    required this.lightTheme,
    required this.darkTheme,
  });
  final String name;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  @override
  String toString() {
    return name;
  }
}

@immutable
class VioletTheme extends AppTheme {
  factory VioletTheme() {
    return VioletTheme._();
  }

  VioletTheme._()
      : super(
          name: 'Violet',
          lightTheme: _buildTheme(violet.lightColorScheme),
          darkTheme: _buildTheme(violet.darkColorScheme),
        );
}

@immutable
class GreenTheme extends AppTheme {
  factory GreenTheme() {
    return GreenTheme._();
  }

  GreenTheme._()
      : super(
          name: 'Green',
          lightTheme: _buildTheme(green.lightColorScheme),
          darkTheme: _buildTheme(green.darkColorScheme),
        );
}

@immutable
class FireTheme extends AppTheme {
  factory FireTheme() {
    return FireTheme._();
  }

  FireTheme._()
      : super(
          name: 'Fire',
          lightTheme: _buildTheme(fire.lightColorScheme),
          darkTheme: _buildTheme(fire.darkColorScheme),
        );
}

@immutable
class WheatTheme extends AppTheme {
  factory WheatTheme() {
    return WheatTheme._();
  }

  WheatTheme._()
      : super(
          name: 'Wheat',
          lightTheme: _buildTheme(wheat.lightColorScheme),
          darkTheme: _buildTheme(wheat.darkColorScheme),
        );
}

@immutable
class DynamicTheme extends AppTheme {
  factory DynamicTheme.fromSeed(Color seedColor) {
    return DynamicTheme._(seedColor);
  }

  DynamicTheme._(Color seedColor)
      : super(
          name: 'Dynamic',
          lightTheme: _buildTheme(
            ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: _buildTheme(
            ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.dark,
            ),
          ),
        );
}
