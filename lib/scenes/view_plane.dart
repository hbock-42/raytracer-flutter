import 'package:vector_math/vector_math_64.dart';

class ViewPlane {
  final Vector3 origin;
  final double width;
  final double height;
  final Vector3 topLeft;

  ViewPlane({
    required this.origin,
    required this.width,
    required this.height,
  }) : topLeft = origin + Vector3(-width / 2, height / 2, 0);
}
