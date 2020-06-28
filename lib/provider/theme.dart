import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData currentThemeData = ThemeData.light();

// toogle theme between dark and light theme
  void toogleTheme() {
    currentThemeData == ThemeData.light()
        ? currentThemeData = ThemeData.dark()
        : currentThemeData = ThemeData.light();

    notifyListeners();
  }
}
