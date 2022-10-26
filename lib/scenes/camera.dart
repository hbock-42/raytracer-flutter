import 'package:vector_math/vector_math_64.dart';

class Camera {
  final Vector3 position;
  final Vector3 direction;
  final Vector3 up;
  final Vector3 right;

  Camera({
    required this.position,
    required Vector3 direction,
    required this.up,
    required this.right,
  }) : direction = direction.normalized();
}
