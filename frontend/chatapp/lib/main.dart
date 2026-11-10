import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'utils/theme.dart';

final ThemeNotifier themeNotifier = ThemeNotifier();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
