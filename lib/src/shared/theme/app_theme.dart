import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const fontFamily = 'Poppins';

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff604ee8),
      Color(0xffd66afc),
    ],
  );

  static const primaryColor = Color(0xFF915af0);
  static const _background = Color(0xff1b1f38);
  static const _onBackground = Color(0xff15172c);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        canvasColor: _background,
        colorScheme: ThemeData().colorScheme.copyWith(
              background: _background,
              onBackground: _onBackground,
            ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
        ),
        fontFamily: fontFamily,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(9),
          filled: true,
          labelStyle: const TextStyle(color: Color(0xFF3A3D61)),
          hintStyle: const TextStyle(color: Color(0xFF3A3D61)),
          floatingLabelStyle: const TextStyle(color: primaryColor),
          suffixIconColor: const Color(0xFF3A3D61),
          prefixIconColor: const Color(0xFF3A3D61),
          fillColor: _onBackground,
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red.shade900, width: 2),
          ),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red.shade900, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: _background.withOpacity(0.95),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: _onBackground.withOpacity(0.95),
        ),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: _onBackground,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          backgroundColor: _onBackground,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
      );
}
