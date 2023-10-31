import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 22, 32, 47),
  // backgroundColor: const Color.fromRGBO(225, 225, 225, 1),
  primaryColor: const Color.fromRGBO(
      76, 158, 235, 1), //const Color.fromRGBO(76, 158, 235, 1),
  hintColor: const Color.fromRGBO(104, 118, 132, 1),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 22, 32, 47),
    selectedItemColor: Colors.white,
    elevation: 0,
  ),
  appBarTheme: const AppBarTheme(
    color: Color.fromARGB(255, 22, 32, 47),
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
  // textTheme: AppTextTheme.darkTheme,
  brightness: Brightness.dark,
);
