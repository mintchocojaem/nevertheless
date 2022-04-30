import 'package:flutter/material.dart';
import 'package:pomodoro/app/ui/components/dong_colors.dart';

class DongThemes {


  // MaterialApp에서 theme: DongThemes.lightTheme 하면 라이트 테마로 바뀐다.
  static ThemeData get lightTheme => ThemeData(
        primarySwatch: DongColors.primaryMeterialColor,
        fontFamily: 'GmarketSansTTF',
        textTheme: _textTheme,
    appBarTheme: _appBarTheme,
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.white,
    brightness: Brightness.light
      );
  static ThemeData get darkTheme => ThemeData(
      primarySwatch: DongColors.primaryMeterialColor,
      fontFamily: 'GmarketSansTTF',
      textTheme: _textTheme,
      // scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.white,
      brightness: Brightness.dark
  );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: DongColors.primaryColor),
    elevation: 0,
  );

  static const TextTheme _textTheme = TextTheme(
    headline4: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
  );
}
