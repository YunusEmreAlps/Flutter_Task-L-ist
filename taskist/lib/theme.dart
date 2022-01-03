// Words Quiz

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:taskist/util/app_constant.dart';

// Our light/Primary Theme
ThemeData themeData(BuildContext context) {
  return ThemeData(
    appBarTheme: appBarTheme,
    primaryColor: AppConstant.colorPrimary,
    accentColor: AppConstant.kAccentLightColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      secondary: AppConstant.kSecondaryLightColor,
      // on light theme surface = Colors.white by default
    ),
    backgroundColor: AppConstant.colorPageBg,
    iconTheme: IconThemeData(color: AppConstant.kBodyTextColorLight),
    accentIconTheme: IconThemeData(color: AppConstant.kAccentIconLightColor),
    primaryIconTheme: IconThemeData(color: AppConstant.kPrimaryIconLightColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyText1: TextStyle(color: AppConstant.kBodyTextColorLight),
      bodyText2: TextStyle(color: AppConstant.kBodyTextColorLight),
      headline4: TextStyle(color: AppConstant.kTitleTextLightColor, fontSize: 32),
      headline1: TextStyle(color: AppConstant.kTitleTextLightColor, fontSize: 80),
    ),
  );
}

// Dark Theme
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: AppConstant.colorPrimary,
    accentColor: AppConstant.kAccentDarkColor,
    scaffoldBackgroundColor: Color(0xFF1f1d2b), // Color(0xFF0D0C0E), Color(0xFF121212)
    appBarTheme: appBarTheme,
    colorScheme: ColorScheme.light(
      secondary: AppConstant.kSecondaryDarkColor,
      surface: AppConstant.kSurfaceDarkColor,
    ),
    backgroundColor: Color(0xFF1f1d2b),
    iconTheme: IconThemeData(color: AppConstant.kBodyTextColorDark),
    accentIconTheme: IconThemeData(color: AppConstant.kAccentIconDarkColor),
    primaryIconTheme: IconThemeData(color: AppConstant.kPrimaryIconDarkColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyText1: TextStyle(color: AppConstant.kBodyTextColorDark),
      bodyText2: TextStyle(color: AppConstant.kBodyTextColorDark),
      headline4: TextStyle(color: AppConstant.kTitleTextDarkColor, fontSize: 32),
      headline1: TextStyle(color: AppConstant.kTitleTextDarkColor, fontSize: 80),
    ),
  );
}

AppBarTheme appBarTheme = AppBarTheme(color: Colors.transparent, elevation: 0);