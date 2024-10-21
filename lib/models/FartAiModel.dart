import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';

class FartModel {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/yamnet.tflite');
    } catch (e) {
      log('Failed to load model: $e');
    }
  }

  List<double> runModel(List<double> audioData) {
    var input = audioData;
    var output = List.filled(521, 0.0).reshape([1, 521]);

    _interpreter.run(input, output);
    return output[0];
  }
}
