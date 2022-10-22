import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

import 'i_light.dart';

class PointLight implements ILight {
  @override
  final Vector3 position;
  @override
  final Color color;
  @override
  final int intensity;

  PointLight({
    required this.position,
    required this.color,
    required this.intensity,
  });
}
