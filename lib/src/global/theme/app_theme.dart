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

  static const _onPrimaryColor = Color(0xffe6e5e5);
  static const _secondaryColor = Color(0xff6d6d88);
  static const _onSecondaryColor = Color(0xff55556c);

  static const _backgroundColor = Color(0xff171720);
  static const _onBackgroundColor = Color(0xff1e1e2a);

  static const _surfaceColor = Color(0xFF1d1d29);
  static const _surfaceTintcolor = Color(0xff1b1b1d);

  static const _onSurfaceColor = Color(0xff1b1b26);
  static const _onSurfaceVariantColor = Color(0xff232325);

  static const _outlineColor = Color(0xff242431);
  static const _outlineVariantColor = Color(0xFF272727); // 0xFF1F1F1F

  static final _errorColor = Colors.red.shade300;

  static ThemeData get dark => ThemeData(
        // useMaterial3: true,
        scaffoldBackgroundColor: _backgroundColor,
        primaryColor: primaryColor,
        canvasColor: _backgroundColor,
        splashColor: _onSurfaceColor,
        colorScheme: ThemeData().colorScheme.copyWith(
              background: _backgroundColor,
              onBackground: _onBackgroundColor,
              primary: primaryColor,
              onPrimary: _onPrimaryColor,
              secondary: _secondaryColor,
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
            disabledForegroundColor: primaryColor.withOpacity(0.3),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: _backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: _onSurfaceColor.withOpacity(0.95),
        ),
        appBarTheme: const AppBarTheme(
          shadowColor: Colors.transparent,
          foregroundColor: _onPrimaryColor,
          backgroundColor: _backgroundColor,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: _onPrimaryColor,
            fontSize: 19.5,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: _backgroundColor,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: _backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          linearMinHeight: 1,
          linearTrackColor: primaryColor.withOpacity(0.4),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: _surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(
            color: _onPrimaryColor,
            fontSize: 15,
            fontFamily: fontFamily,
          ),
        ),
      );
}
