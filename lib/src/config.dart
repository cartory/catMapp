import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'globals.dart';

final box = GetStorage();

class Routes {
  static const home = "/home";
  // auth
  static const login = "/login";
  static const profile = "/profile";
  // tasks module
  // schedule module
  // inventory module
  static const inventory = "/inventory";
}

final getPages = [
  GetPage(name: Routes.home, page: () => const HomePage()),
  // auth
  GetPage(name: Routes.login, page: () => LoginPage()),
  GetPage(name: Routes.inventory, page: () => const InventoryPage())
  // GetPage(name: Routes.profile, page: () => const ProfilePage())
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
    secondaryVariant: const Color(0xffEB008B),
  ),
  // checkboxThemData
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3),
    ),
  ),
  // textSelectionTheme
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0x44383D4A),
    selectionHandleColor: Colors.lightBlue,
  ),
  // BottomNavigationBarThemeData
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xff383D4A),
    unselectedItemColor: Color(0xff383D4A),
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    // selected
    // selectedLabelStyle: TextStyle(color: Colors.white),
    selectedLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    selectedIconTheme: IconThemeData(color: Color(0xffEB008B)),
    // unselected
    unselectedLabelStyle: TextStyle(color: Color(0xff383D4A)),
    unselectedIconTheme: IconThemeData(color: Color(0xff383D4A)),
  ),
  // appBar Theme
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: false,
    toolbarHeight: Get.width * .16,
    backgroundColor: Colors.white,
    iconTheme: const IconThemeData(
      size: 20,
      color: Color(0xff383D4A),
    ),
    titleTextStyle: const TextStyle(
      fontSize: 18,
      wordSpacing: 0,
      letterSpacing: 0,
      color: Colors.black,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: const IconThemeData(
      size: 34,
      color: Colors.grey,
    ),
  ),
  //
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: .3,
      alignment: Alignment.center,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      textStyle: const TextStyle(
        fontSize: 14.5,
        fontFamily: 'Roboto',
        wordSpacing: 0,
        letterSpacing: 0,
      ),
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
