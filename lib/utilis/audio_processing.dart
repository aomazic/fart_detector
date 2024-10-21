import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/FartAiModel.dart';

class AudioDetector {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FartModel _fartModel = FartModel();
  final StreamController<Uint8List> _audioStreamController =
      StreamController<Uint8List>();
  final fartCategoryIndex = 55;

  Future<void> init() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      await _recorder.openRecorder();
      print("Recorder opened successfully");
      await _fartModel.loadModel();
    } else {
      print("Microphone permission not granted");
    }
  }

  Future<void> startListening(Function onFartDetected) async {
    List<Uint8List> audioBuffer = [];
    int sampleRate = 16000;

    _audioStreamController.stream.listen((audioData) async {
      audioBuffer.add(audioData);

      int totalSamples = audioBuffer.fold(0, (sum, data) => sum + data.length);
      int samplesPerSecond = sampleRate * 1;

      if (totalSamples >= samplesPerSecond) {
        Uint8List combinedAudio = Uint8List(totalSamples);
        int offset = 0;
        for (var data in audioBuffer) {
          combinedAudio.setRange(offset, offset + data.length, data);
          offset += data.length;
        }

        List<double> input = preprocessAudio(combinedAudio);

        List<double> output = _fartModel.runModel(input);
        print("Fart probability: ${output[fartCategoryIndex]}");

        if (output[fartCategoryIndex] > 0.5) {
          onFartDetected();
        }

        audioBuffer.clear();
      }
    });

    await _recorder.startRecorder(
      toStream: _audioStreamController.sink,
      codec: Codec.pcm16,
    );

    print("Recorder started");
  }

  List<double> preprocessAudio(Uint8List audioData) {
    return audioData.map((byte) => byte.toDouble() / 32768.0).toList();
  }

  Future<void> stopListening() async {
    await _recorder.stopRecorder();
  }

  void dispose() {
    _recorder.closeRecorder();
    _audioStreamController.close();
  }
}
