import 'package:flutter/material.dart';
import 'constants.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryBlue,
  scaffoldBackgroundColor: AppColors.lightBackground,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryBlue,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightText,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.lightText),
    titleTextStyle: TextStyle(
      color: AppColors.lightText,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  dividerColor: AppColors.lightDivider,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryBlueDark,
  scaffoldBackgroundColor: AppColors.darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryBlueDark,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkText,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.darkText),
    titleTextStyle: TextStyle(
      color: AppColors.darkText,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  dividerColor: AppColors.darkDivider,
);
