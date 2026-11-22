import 'dart:math';
import 'package:flutter/material.dart';

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


  factory Responsive.of(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Responsive._(
      screenWidth: mq.size.width,
      screenHeight: mq.size.height,
    );
  }

  double w(double size) => size * _scaleWidth;

  double h(double size) => size * _scaleHeight;

  double sp(double size) {
    final scaled = size * _scaleDiagonal;
    return scaled.clamp(size * 0.8, size * 1.3);
  }

  double icon(double size) {
    final scaled = size * _scaleDiagonal;
    return scaled.clamp(size * 0.85, size * 1.25);
  }

  double r(double radius) => radius * _scaleWidth;

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

  EdgeInsets symmetricPadding({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: w(horizontal),
      vertical: h(vertical),
    );
  }

  bool get isSmallPhone => screenWidth < 360;

  bool get isLargePhone => screenWidth > 420;
}
