import 'package:flutter/material.dart';

class Mat {
  final Color color;
  final double diffuseCoef;
  final double ambientCoef;
  final double specularCoef;

  Mat({
    required this.color,
    required this.diffuseCoef,
    required this.ambientCoef,
    required this.specularCoef,
  });
}
