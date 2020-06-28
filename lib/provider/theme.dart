import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // set the current theme by user choice
  ThemeData currentThemeData = ThemeData.light();

// toogle theme between dark and light theme
  void toogleTheme() {
    if (currentThemeData == ThemeData.light()) {
      currentThemeData = ThemeData.dark();
    } else {
      currentThemeData = ThemeData.light();
    }

    notifyListeners();
  }
}
