import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

abstract class ILight {
  Vector3 get position;

  Color get color;

  int get intensity;
}
