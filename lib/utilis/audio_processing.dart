import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/fart_ai_model.dart';

class AudioDetector {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FartModel _fartModel = FartModel();
  final StreamController<Uint8List> _audioStreamController =
      StreamController<Uint8List>();
  final fartCategoryIndex = 55;
  static const int targetSampleRate = 16000;
  static const int frameSize = 15600;
  static const int overlapSize = 7800;

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
    List<int> audioBuffer = []; // store raw PCM samples

    _audioStreamController.stream.listen((audioData) async {
      // Convert Uint8List (bytes) to a list of PCM samples (signed 16-bit integers)
      List<int> pcmSamples = audioData.buffer.asInt16List();
      audioBuffer.addAll(pcmSamples);

      // Process the audio when we have at least 15600 samples
      if (audioBuffer.length >= frameSize) {
        List<int> frameSamples = audioBuffer.sublist(0, frameSize);
        audioBuffer.removeRange(0, frameSize - overlapSize);

        List<double> input = preprocessAudio(frameSamples);

        List<double> output = _fartModel.runModel(input);

        if (output[fartCategoryIndex] > 0.5) {
          onFartDetected();
        }
      }
    });

    await _recorder.startRecorder(
      toStream: _audioStreamController.sink,
      codec: Codec.pcm16,
      sampleRate: targetSampleRate,
    );

    print("Recorder started");
  }

  List<double> preprocessAudio(List<int> audioData) {
    // Convert PCM 16-bit signed integer samples to float32 normalized values in range [-1.0, +1.0]
    return audioData.map((sample) => sample.toDouble() / 32768.0).toList();
  }

  Future<void> stopListening() async {
    await _recorder.stopRecorder();
  }

  void dispose() {
    _recorder.closeRecorder();
    _audioStreamController.close();
  }
}
