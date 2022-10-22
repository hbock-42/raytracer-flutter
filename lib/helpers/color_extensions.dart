import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color operator *(double other) {
    return Color.fromRGBO((red * other).toInt(), (green * other).toInt(), (blue * other).toInt(), opacity);
  }

  Color operator +(Color other) {
    return Color.fromRGBO(min(255, red + other.red), min(255, green + other.green), min(255, blue + other.blue), 1);
  }

  Color multiply(Color other) {
    return Color.fromRGBO(
      (red * other.red) ~/ 0xff,
      (green * other.green) ~/ 0xff,
      (blue * other.blue) ~/ 0xff,
      opacity,
    );
  }
}
