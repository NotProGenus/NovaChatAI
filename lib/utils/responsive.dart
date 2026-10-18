import 'dart:math';
import 'package:flutter/material.dart';

/// A responsive utility class that scales UI elements proportionally
/// based on screen dimensions. Designed against a baseline of 392x856
/// (a standard Android phone like Pixel 5).
class Responsive {
  static const double _baseWidth = 392.0;
  static const double _baseHeight = 856.0;

  final double screenWidth;
  final double screenHeight;
  final double _scaleWidth;
  final double _scaleHeight;
  final double _scaleDiagonal;

  Responsive._({required this.screenWidth, required this.screenHeight})
      : _scaleWidth = screenWidth / _baseWidth,
        _scaleHeight = screenHeight / _baseHeight,
        _scaleDiagonal = sqrt(screenWidth * screenWidth + screenHeight * screenHeight) /
            sqrt(_baseWidth * _baseWidth + _baseHeight * _baseHeight);

  /// Create from BuildContext using MediaQuery
  factory Responsive.of(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Responsive._(
      screenWidth: mq.size.width,
      screenHeight: mq.size.height,
    );
  }

  /// Scale a value based on screen width (good for horizontal padding, widths)
  double w(double size) => size * _scaleWidth;

  /// Scale a value based on screen height (good for vertical padding, heights)
  double h(double size) => size * _scaleHeight;

  /// Scale a font size using diagonal scaling (balanced for readability).
  /// Clamped between 0.8x and 1.3x of original size for very small/large phones.
  double sp(double size) {
    final scaled = size * _scaleDiagonal;
    return scaled.clamp(size * 0.8, size * 1.3);
  }

  /// Scale icon size — uses diagonal scaling with slightly tighter clamp
  double icon(double size) {
    final scaled = size * _scaleDiagonal;
    return scaled.clamp(size * 0.85, size * 1.25);
  }

  /// Scale radius values proportionally
  double r(double radius) => radius * _scaleWidth;

  /// Responsive EdgeInsets with width-based horizontal and height-based vertical
  EdgeInsets padding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: w(left),
      top: h(top),
      right: w(right),
      bottom: h(bottom),
    );
  }

  /// Responsive symmetric EdgeInsets
  EdgeInsets symmetricPadding({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: w(horizontal),
      vertical: h(vertical),
    );
  }

  /// Whether the screen is a small phone (width < 360)
  bool get isSmallPhone => screenWidth < 360;

  /// Whether the screen is a large phone (width > 420)
  bool get isLargePhone => screenWidth > 420;
}
