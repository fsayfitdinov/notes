import 'package:flutter/material.dart';

import 'constants.dart';

class AppThemeData {
  AppThemeData._();

  static ThemeData themeData() => ThemeData(
        scaffoldBackgroundColor: kMainColor,
        appBarTheme: _appBarTheme(),
        brightness: Brightness.dark,
        primarySwatch: kWhite,
        inputDecorationTheme: _decorationTheme(),
        fontFamily: 'Montserrat',
      );

  static AppBarTheme _appBarTheme() => const AppBarTheme(
        elevation: 0,
        backgroundColor: kMainColor,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
      );

  static InputDecorationTheme _decorationTheme() {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.transparent),
    );
    return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: kSecondaryColor,
      filled: true,
      // errorBorder: outlineInputBorder,
      border: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      disabledBorder: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      focusColor: Colors.black,
    );
  }
}
