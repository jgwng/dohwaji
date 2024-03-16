import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFonts{
  static const String bold = 'Suite Bold';
  static const String medium = 'Noto Sans SC';
  static const String semiBold = 'Pretendard-SemiBold';
}

class AppThemes {
  AppThemes._();
  static const Color mainColor = Color.fromRGBO(25, 23, 26, 1.0);
  static const Color textColor = Color(0xff222831);
  static const Color backgroundColor = Color(0xfffffafa);
  static const Color pointColor = Color(0xff7D5A50);

  static const Color disableColor = Color.fromRGBO(178, 178, 178, 1.0);
  static const Color noticeColor =  Color.fromARGB(255, 77, 82, 86);
  static const Color hintColor =  Color.fromARGB(255,169, 175, 179);


  static const defaultTextColor = Colors.white;
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
        color: defaultTextColor),
    headline2: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: defaultTextColor),
    subtitle1: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: defaultTextColor),
    subtitle2: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: defaultTextColor),
    bodyText1: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: defaultTextColor),
    bodyText2: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: defaultTextColor),
  );
}