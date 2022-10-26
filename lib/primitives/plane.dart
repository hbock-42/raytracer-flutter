import 'package:vector_math/vector_math_64.dart';

import '../constants.dart';
import '../materials/mat.dart';
import 'i_primitive.dart';

class Plane implements IPrimitive {
  final Vector3 normal;
  final Vector3 p0;
  @override
  final Mat material;

  Plane({
    required Vector3 normal,
    required this.p0,
    required this.material,
  }) : normal = normal.normalized();

  @override
  double intersect(Ray ray) {
    final dot = ray.direction.dot(normal);
    if (dot.abs() < hitThreshold) return double.infinity;

    final p0RayOrigin = p0 - ray.origin;
    final t = p0RayOrigin.dot(normal) / dot;
    if (t < hitThreshold) return double.infinity;
    return t;
  }

  @override
  Vector3 normalAtPoint(Vector3 hitPoint, Ray ray) {
    // return normal;
    final dot = ray.direction.dot(normal);
    return dot > 0 ? -normal : normal;
  }
}
