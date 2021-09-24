import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

import 'pages/home_page.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/profile_page.dart';

final box = GetStorage();

class Routes {
  static const home = "/home";
  // auth
  static const login = "/login";
  static const profile = "/profile";
  // tasks module
  // schedule module
  // inventory module
}

final getPages = [
  GetPage(name: Routes.home, page: () => const HomePage()),
  // auth
  GetPage(name: Routes.login, page: () => const LoginPage()),
  GetPage(name: Routes.profile, page: () => const ProfilePage())
];

// THEME STYLE
final themeData = ThemeData(
  fontFamily: 'Roboto',
  backgroundColor: const Color(0xffDCE1E6),
  scaffoldBackgroundColor: const Color(0xffDCE1E6),
  // colorScheme
  colorScheme: ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.light,
    background: const Color(0xffDCE1E6),
    //
    primary: const Color(0xff0D27D6),
    primaryVariant: const Color(0xff4757D5),
    //
    secondary: const Color(0xff383D4A),
    secondaryVariant: const Color(0xffA8877B),
  ),
  // BottomNavigationBarThemeData
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xff383D4A),
    unselectedItemColor: Colors.white,
    type: BottomNavigationBarType.shifting,
    // selected
    selectedLabelStyle: TextStyle(color: Colors.white),
    selectedIconTheme: IconThemeData(color: Colors.white),
    // unselected
    unselectedLabelStyle: TextStyle(color: Color(0xff383D4A)),
    unselectedIconTheme: IconThemeData(color: Color(0xff383D4A)),
  ),
  // appBar Theme
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
  ),
  //
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: .3,
      alignment: Alignment.center,
      backgroundColor: Colors.white,
      primary: const Color(0xaa000000),
      side: const BorderSide(width: 0, color: Colors.transparent),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  ),
  // inputdecoration theme
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
  ),
);
