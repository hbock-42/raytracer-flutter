import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

import '../helpers/color_extensions.dart';
import '../lights/i_light.dart';
import '../materials/mat.dart';

Color computeAmbientShading({
  required Mat material,
}) {
  final Color color = material.color * material.ambientCoef;
  return color;
}

Color computeDiffuseShading({
  required Mat material,
  required Vector3 normal,
  required Vector3 lightDir,
  required double lightIntensityRate,
}) {
  final fctr = max(0, normal.dot(-lightDir));
  final Color color = material.color * (material.diffuseCoef * fctr * lightIntensityRate);
  return color;
}

Color computeSpecularShading({
  required Mat material,
  required ILight light,
  required Vector3 normal,
  required Vector3 lightDir,
  required Vector3 ray,
  required double lightIntensityRate,
}) =>
    phongHighlight(
      material: material,
      light: light,
      normal: normal,
      lightDir: lightDir,
      ray: ray,
      lightIntensityRate: lightIntensityRate,
    );

Color phongHighlight({
  required Mat material,
  required ILight light,
  required Vector3 normal,
  required Vector3 lightDir,
  required Vector3 ray,
  required double lightIntensityRate,
}) {
  final reflectDir = -lightDir - (normal * 2.0 * normal.dot(-lightDir));
  final highlightFactor = ray.dot(reflectDir).clamp(0, 1);
  final Color color = light.color * (material.specularCoef * highlightFactor * lightIntensityRate);
  return color;
}
