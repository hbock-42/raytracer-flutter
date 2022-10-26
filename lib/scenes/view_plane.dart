import 'package:vector_math/vector_math_64.dart';

import 'camera.dart';

class ViewPlane {
  final Camera camera;
  final double width;
  final double height;
  final Vector3 topLeft;
  final double distFromCamera;

  ViewPlane({
    required this.camera,
    required this.width,
    required this.height,
    required this.distFromCamera,
  }) : topLeft = camera.position + camera.direction * distFromCamera + Vector3(-width / 2, height / 2, 0);
}
