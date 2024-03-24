import 'package:flutter/material.dart';

class AppFonts {
  static const String bold = 'Suite Bold';
  static const String medium = 'Noto Sans SC';
  static const String semiBold = 'Pretendard-SemiBold';
}

class AppThemes {
  AppThemes._();
  static const Color textColor = Color(0xff222222);
  static const Color backgroundColor = Color(0xfffffafa);
  static const Color pointColor = Color(0xff2B6747);

  static const Color disableColor = Color.fromRGBO(178, 178, 178, 1.0);
  static const Color noticeColor = Color.fromARGB(255, 77, 82, 86);
  static const Color hintColor = Color.fromARGB(255, 169, 175, 179);

  static const buttonTextColor = Color(0xFFF6F5EE);
  static const mobileBackgroundColor = Color.fromRGBO(238, 238, 241, 1.0);

  static const TextTheme textTheme = TextTheme(
    button: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: Colors.white),
    headline1: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    headline2: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    subtitle1: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    subtitle2: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    bodyText1: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    bodyText2: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
  );
}
