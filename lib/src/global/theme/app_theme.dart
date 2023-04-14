import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const fontFamily = 'Poppins';

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      // * Color(0xffd462b7),
      // * Color(0xffed978f),
      Color(0xff604ee8),
      Color(0xffd66afc),
    ],
  );

  static const primaryColor = Color(0xFF915af0);

  static const _backgroundColor = Color(0xff000000);

  static const _onBackgroundColor = Color(0xff0b0b0d);

  static const _surfaceColor = Color(0xff0f0e10);
  static const _surfaceTintcolor = Color(0xff1b1b1d);

  /// Utilizado normalmente em BottomSheet, Dialog...
  static const _onSurfaceColor = Color(0xff161618);
  static const _onSurfaceVariantColor = Color(0xff232325);

  /// Utilizado normalmente em textos, icones...
  static const _onPrimaryColor = Color(0xffe6e5e5);

  static const _onSecondaryColor = Color(0xff444348);

  static const _outlineColor = Color(0xFF191919);

  // 0xFF1F1F1F
  static const _outlineVariantColor = Color(0xFF272727);

  static final _errorColor = Colors.red.shade300;

  static ThemeData get dark => ThemeData(
        /// useMaterial3: true,
        primaryColor: primaryColor,
        canvasColor: _backgroundColor,
        splashColor: _onSurfaceColor,
        colorScheme: ThemeData().colorScheme.copyWith(
              background: _backgroundColor,
              onBackground: _onBackgroundColor,
              primary: primaryColor,
              onPrimary: _onPrimaryColor,
              onSecondary: _onSecondaryColor,
              surface: _surfaceColor,
              onSurface: _onSurfaceColor,
              onSurfaceVariant: _onSurfaceVariantColor,
              surfaceTint: _surfaceTintcolor,
              outline: _outlineColor,
              outlineVariant: _outlineVariantColor,
              error: _errorColor,
            ),
        textTheme: const TextTheme(
          labelLarge: TextStyle(color: _onSecondaryColor),
          labelMedium: TextStyle(
            color: _onSecondaryColor,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(color: _onPrimaryColor),
          bodyMedium: TextStyle(
            color: _onPrimaryColor,
            // color: _onSecondaryColor,
            // fontSize: 14,
          ),
          bodyLarge: TextStyle(color: _onPrimaryColor),
          titleLarge: TextStyle(
            color: _onPrimaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            color: _onPrimaryColor,
            fontSize: 15,
          ),
          titleSmall: TextStyle(color: _onPrimaryColor),
          headlineSmall: TextStyle(
            color: _onPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        fontFamily: fontFamily,
        iconTheme: const IconThemeData(
          color: _onPrimaryColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(9),
          filled: true,
          labelStyle: const TextStyle(color: _onSecondaryColor),
          hintStyle: const TextStyle(color: _onSecondaryColor),
          floatingLabelStyle: const TextStyle(color: primaryColor),
          suffixIconColor: _onSecondaryColor,
          prefixIconColor: _onSecondaryColor,
          fillColor: _surfaceColor,
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
            borderSide: BorderSide(color: _errorColor, width: 2),
          ),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: _errorColor, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.minPositive, 42),
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: primaryColor,
            foregroundColor: _onPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            minimumSize: const Size(double.minPositive, 42),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: _onSurfaceColor,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: _onSurfaceColor.withOpacity(0.95),
        ),
        appBarTheme: const AppBarTheme(
          shadowColor: Colors.transparent,
          foregroundColor: _onPrimaryColor,
          backgroundColor: _backgroundColor,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: _onPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: _onSurfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          linearMinHeight: 1,
          linearTrackColor: primaryColor.withOpacity(0.4),
        ),
      );
}
