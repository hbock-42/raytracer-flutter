import 'dart:math';

import 'package:vector_math/vector_math_64.dart';

import '../constants.dart';
import '../materials/mat.dart';
import 'i_primitive.dart';

class Sphere implements IPrimitive {
  final Vector3 center;
  final double radius;
  @override
  final Mat material;

  Sphere({
    required this.center,
    required this.radius,
    required this.material,
  });

  @override
  double intersect(Ray r) {
    final dx = r.direction.x;
    final dy = r.direction.y;
    final dz = r.direction.z;

    final a = dx * dx + dy * dy + dz * dz;
    final b = 2 * dx * (r.origin.x - center.x) + 2 * dy * (r.origin.y - center.y) + 2 * dz * (r.origin.z - center.z);
    final c = center.x * center.x +
        center.y * center.y +
        center.z * center.z +
        r.origin.x * r.origin.x +
        r.origin.y * r.origin.y +
        r.origin.z * r.origin.z -
        2 * (center.x * r.origin.x + center.y * r.origin.y + center.z * r.origin.z) -
        radius * radius;
    final d = b * b - 4 * a * c;
    if (d <= 0) return double.infinity;
    final dsc = 2 * a;
    final sqd = sqrt(d);
    double t = (-b - sqd) / dsc;
    if (t > hitThreshold) return t;
    t = (-b + sqd) / dsc;
    if (t > hitThreshold) return t;
    return double.infinity;
  }

  @override
  Vector3 normalAtPoint(Vector3 hitPoint, Ray ray) {
    return (hitPoint - center).normalized();
  }
}
