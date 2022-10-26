import 'package:flutter/material.dart';

class Mat {
  final Color color;
  final double diffuseCoef;
  final double ambientCoef;
  final double shininess;
  final double specularCoef;

  Mat({
    required this.color,
    required this.diffuseCoef,
    required this.ambientCoef,
    required this.shininess,
    required this.specularCoef,
  }) :
        // sum of coef must be 1. Since equality on [double] is bad we test a close comparision
        assert(
          ((diffuseCoef + ambientCoef + specularCoef) - 1).abs() < 0.0001,
          'current: ${diffuseCoef + ambientCoef + specularCoef}',
        );
}
