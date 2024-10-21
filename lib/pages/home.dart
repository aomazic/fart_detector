import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/FartData.dart';
import '../painters/radar_painter.dart';
import '../utilis/audio_processing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // Animation controller for radar sweeping line
  late AnimationController _controller;
  late Animation<double> _animation;

  // Dynamic values for info panel
  String threatLevel = 'Moderate';
  String detectionStatus = 'Active';
  String gasComposition = 'Methane 78%';
  String lastKnownFart = '1m South';

  // Console messages
  String consoleMessage = 'System Active...';

  // List to track fart positions, heights, and sizes
  List<FartData> fartDataList = [];

  // Random generator
  final Random random = Random();

  // Audio detector instance
  final AudioDetector _audioDetector = AudioDetector();

  @override
  void initState() {
    super.initState();

    // Initialize the radar controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      await _audioDetector.init();
      _audioDetector.startListening(() {
        detectFart();
      });
    } catch (e) {
      print("Error initializing audio: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioDetector.stopListening(); // Stop audio detection
    _audioDetector.dispose(); // Dispose of the audio resources
    super.dispose();
  }

  // Simulating a new fart detection
  void detectFart() {
    setState(() {
      // Store the current line position, random height, and size
      final double lineXPosition =
          _animation.value * MediaQuery.of(context).size.width;
      final double randomHeight =
          random.nextDouble() * MediaQuery.of(context).size.height;
      final double dotSize = calculateDotSize(threatLevel);

      final fartData = FartData(
        xPosition: lineXPosition,
        yPosition: randomHeight,
        size: dotSize,
        opacity: 1.0,
      );
      fartDataList.add(fartData);
      fadeOutFart(fartData);

      // Update the console and dynamic information
      consoleMessage = 'New Fart Detected!';
      threatLevel = 'High';
      detectionStatus = 'Detected at 3 o\'clock';
      gasComposition = 'Methane 95%';
      lastKnownFart = '2m West';
    });
  }

  void fadeOutFart(FartData fartData) {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        fartData.opacity -= 0.05;
        if (fartData.opacity <= 0.0) {
          fartDataList.remove(fartData);
          timer.cancel();
        }
      });
    });
  }

  // Calculate dot size based on threat level
  double calculateDotSize(String threatLevel) {
    switch (threatLevel) {
      case 'High':
        return 10 + random.nextDouble() * 5; // High threat: larger dot size
      case 'Moderate':
        return 6 + random.nextDouble() * 3; // Moderate threat: medium size
      case 'Low':
        return 3 + random.nextDouble() * 2; // Low threat: smaller dot size
      default:
        return 5; // Default size if threat level is unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: buildRadar(),
        ),
        Expanded(
          flex: 4,
          child: buildInfoPanel(),
        ),
        Expanded(
          flex: 1,
          child: buildConsole(),
        ),
      ],
    );
  }

  Widget buildRadar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: const Color(0xFF2AB82D),
          width: 1.0,
        ),
      ),
      child: CustomPaint(
        painter: RadarPainter(
          linePosition: _animation.value * MediaQuery.of(context).size.width,
          fartDataList:
              fartDataList, // Pass fart positions, heights, and sizes to the painter
        ),
      ),
    );
  }

  Widget buildInfoPanel() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInfoRow('TL:', threatLevel),
              buildInfoRow('DS:', detectionStatus),
              buildInfoRow('GC:', gasComposition),
              buildInfoRow('LKF:', lastKnownFart),
              buildInfoRow('Range', '0-5m')
            ],
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: Text(
              '0m',
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConsole() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        consoleMessage,
        style: const TextStyle(
          color: Colors.green,
          fontSize: 14,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          'Fart detection system',
          style: TextStyle(
            color: Color(0xFF2AB82D),
            fontSize: 18,
          ),
        ),
      ),
      centerTitle: true,
    );
  }
}
