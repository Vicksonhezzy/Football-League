import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  scaffoldBackgroundColor: Colors.white, // Color.fromRGBO(231, 236, 240, 1),
  backgroundColor: Colors.white, // const Color.fromRGBO(225, 225, 225, 1),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 0,
  ),
  primaryColor: const Color.fromRGBO(76, 158, 235, 1),
  hintColor: const Color.fromRGBO(104, 118, 132, 1),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue.shade900;
          }
          return const Color.fromRGBO(76, 158, 235, 1);
        },
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(76, 158, 235, 1),
    shape: CircleBorder(),
  ),
  fontFamily: 'SF Pro Text',
  // textTheme: AppTextTheme.lightTheme,
  brightness: Brightness.light,
);
