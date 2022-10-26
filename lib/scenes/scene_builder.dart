import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors, Sphere;

import '../helpers/color_extensions.dart';
import '../lights/i_light.dart';
import '../primitives/i_primitive.dart';
import '../shading/compute_shading.dart';
import 'camera.dart';
import 'scene.dart';
import 'view_plane.dart';

class SceneBuilder extends Sketch {
  final Scene scene;
  final double halfVpWidth;
  final double halfVpHeight;

  SceneBuilder({required this.scene})
      : halfVpWidth = scene.viewPlane.width / 2,
        halfVpHeight = scene.viewPlane.height / 2;

  Camera get camera => scene.camera;

  ViewPlane get viewPlane => scene.viewPlane;

  List<ILight> get lights => scene.lights;

  List<IPrimitive> get primitives => scene.primitives;

  @override
  Future<void> setup() async {
    size(width: scene.width, height: scene.height);
    noLoop();
    background(color: Colors.black);
  }

  @override
  Future<void> draw() async {
    await loadPixels();
    for (int x = 0; x < scene.width; x++) {
      for (int y = 0; y < scene.height; y++) {
        final windowToWorldPixelPosition =
            viewPlane.topLeft + Vector3(x / scene.width * viewPlane.width, -y / scene.height * viewPlane.height, 0);
        final rayDir = (windowToWorldPixelPosition - camera.position).normalized();
        final ray = Ray.originDirection(camera.position, rayDir);
        IPrimitive? targetHit;
        double minDist = double.infinity;
        for (int index = 0; index < primitives.length; index++) {
          final dist = primitives[index].intersect(ray);
          if (dist < minDist) {
            minDist = dist;
            targetHit = primitives[index];
          }
        }
        Color initialColor = Colors.black;

        if (targetHit != null) {
          initialColor = initialColor +
              computeShading(
                initialColor: initialColor,
                targetHit: targetHit,
                hitDistance: minDist,
                scene: scene,
                ray: ray,
              );
          set(x: x, y: y, color: initialColor);
        } else {
          // print('$x:$y');
        }
      }
    }
    await updatePixels();
    print('drawed');
  }
}
