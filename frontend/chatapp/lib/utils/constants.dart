import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryBlueDark = Color(0xFF1976D2);

  // Gradient colors for NovaChat branding
  static const Color gradientCyan = Colors.cyan;
  static const Color gradientPurple = Colors.deepPurple;
  static const Color gradientPink = Colors.pinkAccent;

  // Light theme
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightDivider = Color(0xFFBDBDBD);

  // Dark theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
  static const Color darkDivider = Color(0xFF424242);

  // Chat
  static const Color userBubble = Color(0xFF2196F3);
  static const Color userBubbleText = Colors.white;
  static const Color aiBubbleLight = Color(0xFFE3F2FD);
  static const Color aiBubbleDark = Color(0xFF1A237E);
  static const Color aiBubbleTextLight = Color(0xFF212121);
  static const Color aiBubbleTextDark = Color(0xFFE0E0E0);

  // Suggestion card
  static const Color suggestionCardLight = Colors.white;
  static const Color suggestionCardDark = Color(0xFF2C2C2C);
  static const Color suggestionIconBg = Color(0xFFE3F2FD);
  static const Color suggestionIconBgDark = Color(0xFF1A237E);
}

class AppGradients {
  static const LinearGradient novaChatGradient = LinearGradient(
    colors: [AppColors.gradientCyan, AppColors.gradientPurple, AppColors.gradientPink],
  );
}
