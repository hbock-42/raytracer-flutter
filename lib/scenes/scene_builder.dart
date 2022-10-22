import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import '../helpers/color_extensions.dart';
import '../lights/i_light.dart';
import '../primitives/i_primitive.dart';
import '../shading/comput_shading.dart';
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
        final rayDir = (windowToWorldPixelPosition - camera.origin).normalized();
        final ray = Ray.originDirection(camera.origin, rayDir);
        IPrimitive? targetHit;
        double minDist = double.infinity;
        for (int index = 0; index < primitives.length; index++) {
          final dist = primitives[index].distance(ray);
          if (dist < minDist) {
            minDist = dist;
            targetHit = primitives[index];
          }
        }
        Color hitColor = Colors.black;
        if (targetHit != null) {
          for (int index = 0; index < lights.length; index++) {
            final hitPoint = camera.origin + ray.direction * minDist;
            final normal = targetHit.normal(hitPoint);
            final lightDir = (hitPoint - lights[index].position).normalized();
            final lightIntensityRate = lights[index].intensity / scene.totalLightsIntensity;

            // check there is no object between hitPoint and light
            final rayToLight = Ray.originDirection(hitPoint, -lightDir);
            bool hit = false;
            for (int i = 0; i < primitives.length; i++) {
              hit = primitives[i].distance(rayToLight) < double.infinity;
              if (hit) break;
            }

            // ambient
            if (index == 0) {
              final ambientColor = computeAmbientShading(material: targetHit.material);
              hitColor = hitColor + ambientColor;
            }
            if (!hit) {
              // diffuse
              final Color diffuseColor = computeDiffuseShading(
                lightDir: lightDir,
                normal: normal,
                material: targetHit.material,
                lightIntensityRate: lightIntensityRate,
              );
              hitColor = hitColor + diffuseColor;

              // specular
              final specularColor = computeSpecularShading(
                material: targetHit.material,
                normal: normal,
                ray: ray.direction,
                lightDir: lightDir,
                light: lights[index],
                lightIntensityRate: lightIntensityRate,
              );
              // print(specularColor);
              hitColor += specularColor;
            }

            // print('${hitColor.red}|${hitColor.green}|${hitColor.blue}');
          }
          set(x: x, y: y, color: hitColor);
        }
      }
    }
    await updatePixels();
    print('drawed');
  }
}
