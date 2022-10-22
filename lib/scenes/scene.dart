import 'dart:core';

import '../lights/i_light.dart';
import '../primitives/i_primitive.dart';
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

  Scene({
    required this.lights,
    required this.primitives,
    required this.camera,
    required this.viewPlane,
    required this.width,
    required this.height,
  }) : totalLightsIntensity = lights.fold(0, (int sum, light) => sum + light.intensity);
}
