import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:flutter_processing_test/primitives/sphere.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors, Sphere, Plane;

import 'lights/point_light.dart';
import 'materials/mat.dart';
import 'primitives/plane.dart';
import 'scenes/camera.dart';
import 'scenes/scene.dart';
import 'scenes/scene_builder.dart';
import 'scenes/view_plane.dart';
import 'shading/compute_shading.dart';

void main() {
  const int windowWidth = 600;
  const int windowHeight = 400;
  final camera = Camera(
    position: Vector3(0, 0, -6),
    direction: Vector3(0, 0, 1).normalized(),
    right: Vector3(1, 0, 0),
    up: Vector3(0, 1, 0),
  );
  runApp(
    MaterialApp(
      home: Processing(
        sketch: SceneBuilder(
          scene: Scene(
            renderAmbient: true,
            renderDiffuse: true,
            renderSpecular: true,
            specularAlgorithm: SpecularAlgorithm.blinnPhong,
            camera: camera,
            lights: [
              // PointLight(position: Vector3(-10, 10, -20), color: Colors.white, intensity: 1),
              // PointLight(position: Vector3(-4, 20, 3), color: Colors.white, intensity: 1),
              // PointLight(position: Vector3(1, 13, 1), color: Colors.white, intensity: 1),
              PointLight(position: Vector3(0, 0, 16), color: Colors.white, intensity: 1),
            ],
            primitives: [
              Sphere(
                center: Vector3(-2, -5, 24),
                radius: 2,
                material:
                    Mat(color: Colors.green, diffuseCoef: 0.52, ambientCoef: 0.18, shininess: 16, specularCoef: 0.3),
              ),
              Plane(
                p0: Vector3(-10, 0, 0),
                normal: Vector3(1, 0, 0),
                material:
                    Mat(color: Colors.green, diffuseCoef: 0.62, ambientCoef: 0.18, shininess: 10, specularCoef: 0.2),
              ),
              Plane(
                p0: Vector3(10, 0, 0),
                normal: Vector3(1, 0, 0),
                material:
                    Mat(color: Colors.red, diffuseCoef: 0.62, ambientCoef: 0.18, shininess: 10, specularCoef: 0.2),
              ),
              Plane(
                p0: Vector3(0, -7, 0),
                normal: Vector3(0, 1, 0),
                material:
                    Mat(color: Colors.blue, diffuseCoef: 0.62, ambientCoef: 0.18, shininess: 10, specularCoef: 0.2),
              ),
              Plane(
                p0: Vector3(0, 0, 40),
                normal: Vector3(0, 0, 1),
                material:
                    Mat(color: Colors.orange, diffuseCoef: 0.62, ambientCoef: 0.18, shininess: 0, specularCoef: 0.2),
              ),
            ],
            viewPlane: ViewPlane(camera: camera, width: 4, height: windowHeight / windowWidth * 4, distFromCamera: 4),
            width: windowWidth,
            height: windowHeight,
          ),
        ),
      ),
    ),
  );
}
