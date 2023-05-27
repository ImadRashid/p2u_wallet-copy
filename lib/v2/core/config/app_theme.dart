import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';

class AppTheme {
  static Color upColor = Color(0xff58A225);
  static Color lightGreen = Color(0xff75E58B);
  static Color downColor = Colors.red;
  static Color primaryColor = Color(0xffFDC227);
  static Color primaryColorLight = Color(0xff5BB15D);
  static Color primaryColorDark = Color(0xff306334);
  static Color dividerColor = Color(0xff71717D);
  static Color hintColor = Color(0xff717D7D);

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: Color(0xff07090d),
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    primaryColorDark: primaryColorDark,
    cardColor: Color(0xff2B2A3B),
    hintColor: hintColor,
    disabledColor: dividerColor,
    dividerColor: dividerColor,
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    appBarTheme: AppBarTheme(
      color: Colors.black,
      centerTitle: true,
      elevation: 0,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        subtitle1: TextStyle(),
        subtitle2: TextStyle(color: lightGreen),
        button: TextStyle(color: dividerColor),
        caption: TextStyle(color: dividerColor),
        headline5: TextStyle(),
        headline6: TextStyle(fontSize: 22),
        overline: TextStyle(letterSpacing: 0),
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.grey.shade50,
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    primaryColorDark: primaryColorDark,
    cardColor: Colors.grey.shade200,
    hintColor: hintColor,
    disabledColor: dividerColor,
    dividerColor: dividerColor,
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: poppinsTextStyle(20, FontWeight.w600, Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        subtitle1: TextStyle(),
        subtitle2: TextStyle(),
        button: TextStyle(),
        caption: TextStyle(),
        headline1: TextStyle(),
        headline2: TextStyle(),
        headline3: TextStyle(),
        headline4: TextStyle(color: Colors.black),
        headline5: TextStyle(),
        headline6: TextStyle(fontSize: 22),
        overline: TextStyle(letterSpacing: 0),
      ),
    ),
  );

  static ShaderCallback shaderCallback = (Rect bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[primaryColorLight, primaryColorDark],
        tileMode: TileMode.mirror,
      ).createShader(bounds);
}
