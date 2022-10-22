import 'package:vector_math/vector_math_64.dart';

import '../materials/mat.dart';

abstract class IPrimitive {
  Mat get material;

  Vector3 normal(Vector3 hitPoint);

  double distance(Ray ray);
}
