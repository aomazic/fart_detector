import 'dart:developer';
import 'dart:io';

import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/mappings.dart';

class FartModel {
  late Interpreter _interpreter;
  final Mappings mappings = Mappings();

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/yamnet.tflite');
      await _loadCategoryMap();
    } catch (e) {
      log('Failed to load model: $e');
    }
  }

  Future<void> _loadCategoryMap() async {
    try {
      final file = File('assets/utils/mappings.csv');
      final lines = await file.readAsLines();
      for (var line in lines.skip(1)) {
        final parts = line.split(',');
        final index = int.parse(parts[0]);
        final displayName = parts[2];
        mappings.soundCategories[index] = displayName;
      }
    } catch (e) {
      log('Failed to load category map: $e');
    }
  }

  List<double> runModel(List<double> audioData) {
    var input = audioData;
    var output = List.filled(521, 0.0).reshape([1, 521]);

    _interpreter.run(input, output);
    printOutput(output[0]);
    return output[0];
  }

  void printOutput(List<double> output) {
    List<int> topIndices = List.generate(output.length, (index) => index);
    topIndices.sort((a, b) => output[b].compareTo(output[a]));
    List<int> top3Indices = topIndices.take(3).toList();

    log("\n");
    for (var index in top3Indices) {
      log("Category ${mappings.soundCategories[index]} : ${output[index]}");
    }
  }
}
