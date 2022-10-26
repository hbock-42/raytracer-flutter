import 'dart:core';

import '../lights/i_light.dart';
import '../primitives/i_primitive.dart';
import '../shading/compute_shading.dart';
import 'camera.dart';
import 'view_plane.dart';

class Scene {
  final List<ILight> lights;
  final int totalLightsIntensity;
  final List<IPrimitive> primitives;
  final Camera camera;
  final ViewPlane viewPlane;
  final int width;
  final int height;
  final bool renderAmbient;
  final bool renderDiffuse;
  final bool renderSpecular;
  final SpecularAlgorithm specularAlgorithm;

  Scene({
    required this.lights,
    required this.primitives,
    required this.camera,
    required this.viewPlane,
    required this.width,
    required this.height,
    required this.specularAlgorithm,
    this.renderAmbient = true,
    this.renderDiffuse = true,
    this.renderSpecular = true,
  }) : totalLightsIntensity = lights.fold(0, (int sum, light) => sum + light.intensity);
}
