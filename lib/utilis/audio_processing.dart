import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/fart_ai_model.dart';

class AudioDetector {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FartModel _fartModel = FartModel();
  final fartCategoryIndex = 55;
  static const int targetSampleRate = 16000;
  static const int frameSize = 15600;
  bool _mRecorderIsInited = false;

  Future<void> init() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      await _recorder.openRecorder();
      print("Recorder opened successfully");
      _mRecorderIsInited = true;
      await _fartModel.loadModel();
    } else {
      print("Microphone permission not granted");
    }
  }

  Future<void> startListening(Function onFartDetected) async {
    if (!_mRecorderIsInited) {
      print("Recorder not initialized");
      return;
    }
    List<int> audioBuffer = [];
    var recordingDataController = StreamController<List<Int16List>>();

    await _recorder.startRecorder(
      toStreamInt16: recordingDataController.sink,
      sampleRate: targetSampleRate,
      codec: Codec.pcm16,
      numChannels: 1,
    );

    recordingDataController.stream.listen((audioData) async {
      audioBuffer.addAll(audioData[0]);
      if (audioBuffer.length >= frameSize) {
        List<int> frameSamples = audioBuffer.sublist(0, frameSize);
        audioBuffer.removeRange(0, frameSize);

        List<double> input = normalizeToFloat(frameSamples);
        List<double> output = _fartModel.runModel(input);

        if (output[fartCategoryIndex] > 0.5) {
          onFartDetected();
        }
      }
    });
  }

  List<double> normalizeToFloat(List<int> audioData) {
    // Normalize Int16List to float32 -1 to 1
    return audioData.map((e) => e / 32768.0).toList();
  }

  Future<void> stopListening() async {
    await _recorder.stopRecorder();
  }

  void dispose() {
    _recorder.closeRecorder();
  }
}