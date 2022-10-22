import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors, Sphere;

import 'lights/point_light.dart';
import 'materials/mat.dart';
import 'primitives/sphere.dart';
import 'scenes/camera.dart';
import 'scenes/scene.dart';
import 'scenes/scene_builder.dart';
import 'scenes/view_plane.dart';

void main() {
  const int windowWidth = 600;
  const int windowHeight = 400;
  runApp(
    MaterialApp(
      home: Processing(
        sketch: SceneBuilder(
          scene: Scene(
            lights: [
              PointLight(position: Vector3(0, 0, 2), color: Colors.white, intensity: 4),
              // PointLight(position: Vector3(-4, 0, 3), color: Colors.white, intensity: 1),
              // PointLight(position: Vector3(1, 0, 1), color: Colors.white, intensity: 1),
              // PointLight(position: Vector3(1, 1, 0), color: Colors.pink, intensity: 1),
            ],
            primitives: [
              Sphere(
                center: Vector3(2, 0, 4),
                radius: 1,
                material: Mat(color: Colors.red, diffuseCoef: 0.72, ambientCoef: 0.18, specularCoef: 0.4),
              ),
              Sphere(
                center: Vector3(-2, 0, 4),
                radius: 1,
                material: Mat(color: Colors.green, diffuseCoef: 0.72, ambientCoef: 0.18, specularCoef: 0.4),
              ),
            ],
            camera: Camera(
              direction: Vector3(0, 0, 1).normalized(),
              origin: Vector3(0, 0, -5),
              right: Vector3(1, 0, 0),
              up: Vector3(0, 1, 0),
            ),
            viewPlane: ViewPlane(origin: Vector3(0, 0, 0), width: 4, height: windowHeight / windowWidth * 4),
            width: windowWidth,
            height: windowHeight,
          ),
        ),
      ),
    ),
  );
}
