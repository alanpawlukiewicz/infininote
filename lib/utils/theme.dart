import 'package:flutter/material.dart';

class AppTheme {
  AppTheme({
    required this.theme,
  });

  final Map<String, dynamic> theme;

  ThemeData get lightTheme {
    ColorScheme colorScheme = theme['Color Scheme'];
    TextTheme textTheme = theme['Text Theme'];

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme().copyWith(
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        foregroundColor: colorScheme.onPrimary,
        titleTextStyle: textTheme.titleLarge!.copyWith(
          color: colorScheme.onPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
          backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
          iconColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.black26, // Kolor okręgu pod kursorem
      ),
    );
  }

  ThemeData get darkTheme {
    ColorScheme colorScheme = theme['Color Scheme'];
    TextTheme textTheme = theme['Text Theme'];

    return ThemeData(
      colorScheme: colorScheme.copyWith(
        brightness: Brightness.dark,
      ),
      textTheme: textTheme.apply(
        bodyColor: Colors.white,
      ),
      appBarTheme: AppBarTheme().copyWith(
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        foregroundColor: colorScheme.onPrimary,
        titleTextStyle: textTheme.titleLarge!.copyWith(
          color: colorScheme.onPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
      drawerTheme: DrawerThemeData(
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      ),
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white,
      ),
      canvasColor: const Color.fromARGB(255, 25, 25, 25),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
          backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
          iconColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(Colors.white),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: const Color.fromARGB(255, 25, 25, 25),
        textStyle: TextStyle(
          color: Colors.white,
        ),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.black26, // Kolor okręgu pod kursorem
      ),
    );
  }

  ThemeMode get themeMode {
    return theme['Theme Mode'];
  }
}
