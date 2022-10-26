import 'dart:math';
import 'dart:ui' hide Scene;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

import '../helpers/color_extensions.dart';
import '../lights/i_light.dart';
import '../materials/mat.dart';
import '../primitives/i_primitive.dart';
import '../scenes/scene.dart';

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

double computeDiffuseValue({
  required Mat material,
  required Vector3 normal,
  required Vector3 lightDir,
  required double lightIntensityRate,
}) {
  final fctr = max(0, normal.dot(-lightDir));
  final double diffuseValue = material.diffuseCoef * fctr * lightIntensityRate;
  return diffuseValue;
}

enum SpecularAlgorithm { phong, blinnPhong }

Color computeSpecularShading({
  required Mat material,
  required ILight light,
  required Vector3 normal,
  required Vector3 lightDir,
  required Vector3 rayDir,
  required double lightIntensityRate,
  required SpecularAlgorithm specularAlgorithm,
}) {
  switch (specularAlgorithm) {
    case SpecularAlgorithm.phong:
      return phongHighlight(
        material: material,
        light: light,
        normal: normal,
        lightDir: lightDir,
        rayDir: rayDir,
        lightIntensityRate: lightIntensityRate,
      );
    case SpecularAlgorithm.blinnPhong:
      return blinnPhongHighLight(
        material: material,
        light: light,
        normal: normal,
        lightDir: lightDir,
        rayDir: rayDir,
        lightIntensityRate: lightIntensityRate,
      );
  }
}

Color phongHighlight({
  required Mat material,
  required ILight light,
  required Vector3 normal,
  required Vector3 lightDir,
  required Vector3 rayDir,
  required double lightIntensityRate,
}) {
  final reflectDir = -lightDir - (normal * 2.0 * normal.dot(-lightDir));
  final phongTerm = rayDir.dot(reflectDir).clamp(0, 1);
  final Color color = light.color * (material.shininess * phongTerm * lightIntensityRate);
  return color;
}

Color blinnPhongHighLight({
  required Mat material,
  required ILight light,
  required Vector3 normal,
  required Vector3 lightDir,
  required Vector3 rayDir,
  required double lightIntensityRate,
}) {
  // https://www.rorydriscoll.com/2009/01/25/energy-conservation-in-games/
  final double normalizationFactor = (material.shininess + 2) *
      (material.shininess + 4) /
      (8 * pi * (pow(2, -material.shininess / 2) + material.shininess));
  final double cosAngleIncidence = normal.dot(-lightDir).clamp(0, 1);
  final halfAngle = (lightDir + rayDir).normalized();
  final double blinnTerm = cosAngleIncidence != 0 && material.shininess != 0
      ? pow(normal.dot(-halfAngle).clamp(0, 1), material.shininess).toDouble()
      : 0;
  final Color color = light.color * (normalizationFactor * material.specularCoef * blinnTerm * lightIntensityRate);
  return color;
}

double computeSpecularValue({
  required Mat material,
  required ILight light,
  required Vector3 normal,
  required Vector3 lightDir,
  required Vector3 rayDir,
  required double lightIntensityRate,
  required SpecularAlgorithm specularAlgorithm,
}) {
  switch (specularAlgorithm) {
    case SpecularAlgorithm.phong:
      return phongHighlightValue(
        material: material,
        light: light,
        normal: normal,
        lightDir: lightDir,
        rayDir: rayDir,
        lightIntensityRate: lightIntensityRate,
      );
    case SpecularAlgorithm.blinnPhong:
      return blinnPhongHighLightValue(
        material: material,
        light: light,
        normal: normal,
        lightDir: lightDir,
        rayDir: rayDir,
        lightIntensityRate: lightIntensityRate,
      );
  }
}

double phongHighlightValue({
  required Mat material,
  required ILight light,
  required Vector3 normal,
  required Vector3 lightDir,
  required Vector3 rayDir,
  required double lightIntensityRate,
}) {
  final reflectDir = -lightDir - (normal * 2.0 * normal.dot(-lightDir));
  final phongTerm = rayDir.dot(reflectDir).clamp(0, 1);
  final double phongValue = material.shininess * phongTerm * lightIntensityRate;
  return phongValue;
}

double blinnPhongHighLightValue({
  required Mat material,
  required ILight light,
  required Vector3 normal,
  required Vector3 lightDir,
  required Vector3 rayDir,
  required double lightIntensityRate,
}) {
  // https://www.rorydriscoll.com/2009/01/25/energy-conservation-in-games/
  final double normalizationFactor = (material.shininess + 2) *
      (material.shininess + 4) /
      (8 * pi * (pow(2, -material.shininess / 2) + material.shininess));
  final double cosAngleIncidence = normal.dot(-lightDir).clamp(0, 1);
  final halfAngle = (lightDir + rayDir).normalized();
  final double blinnTerm = cosAngleIncidence != 0 && material.shininess != 0
      ? pow(normal.dot(-halfAngle).clamp(0, 1), material.shininess).toDouble()
      : 0;
  final double blinnPhongValue = normalizationFactor * material.specularCoef * blinnTerm * lightIntensityRate;
  return blinnPhongValue;
}

Color combineDiffuseSpecularForEnergyConservation({
  required ILight light,
  required Mat material,
  required double lightIntensityRate,
  required double diffuseValue,
  required double specularValue,
  double ambiantValue = 0,
}) {
  final double totalShadingValue = ambiantValue + diffuseValue + specularValue;
  final double correctedDiffuseValue = totalShadingValue > 1 ? 1 - (ambiantValue + specularValue) : diffuseValue;
  final color = material.color * correctedDiffuseValue + light.color * specularValue;
  return color;
}

Color computeShading({
  required Scene scene,
  required Color initialColor,
  required IPrimitive targetHit,
  required Ray ray,
  required double hitDistance,
}) {
  final lights = scene.lights;
  final camera = scene.camera;
  final primitives = scene.primitives;
  Color newColor = initialColor;
  for (int index = 0; index < lights.length; index++) {
    final hitPoint = camera.position + ray.direction * hitDistance;
    final normal = targetHit.normalAtPoint(hitPoint, ray);
    final lightDir = (hitPoint - lights[index].position).normalized();
    final lightIntensityRate = lights[index].intensity / scene.totalLightsIntensity;

    // check there is no object between hitPoint and light
    final rayToLight = Ray.originDirection(hitPoint, -lightDir);
    final lightDist = (lights[index].position - hitPoint).length;
    bool hit = false;
    for (int i = 0; i < primitives.length; i++) {
      hit = primitives[i].intersect(rayToLight) < lightDist;
      if (hit) break;
    }

    double diffuseValue = 0;
    double specularValue = 0;
    if (!hit) {
      // diffuse
      if (scene.renderDiffuse) {
        diffuseValue = computeDiffuseValue(
          lightDir: lightDir,
          normal: normal,
          material: targetHit.material,
          lightIntensityRate: lightIntensityRate,
        );
      }
      // specular
      if (scene.renderSpecular) {
        specularValue = computeSpecularValue(
          material: targetHit.material,
          normal: normal,
          rayDir: ray.direction,
          lightDir: lightDir,
          light: lights[index],
          lightIntensityRate: 1,
          specularAlgorithm: scene.specularAlgorithm,
        );
      }
      newColor += combineDiffuseSpecularForEnergyConservation(
        light: lights[index],
        material: targetHit.material,
        lightIntensityRate: lightIntensityRate,
        diffuseValue: diffuseValue,
        specularValue: specularValue,
      );
    }
  }
  return newColor;
}
