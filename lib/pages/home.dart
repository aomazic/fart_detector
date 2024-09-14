import 'package:fart_detector/radar_painter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildContainer(context),
    );
  }

  Container buildContainer(BuildContext context) {
    final double radarHeight = MediaQuery.of(context).size.height * 0.5;
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          buildRadar(radarHeight),
          buildInfoPanel(),
        ],
      ),
    );
  }

  Positioned buildInfoPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          'Range: 0m-5m',
          textAlign: TextAlign.center,
        ),

      ),
    );
  }

  Positioned buildRadar(double radarHeight) {
    return Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: radarHeight, // Adjust the height as needed
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF2AB82D),
                width: 1.0,
              ),
            ),
            child: CustomPaint(
              painter: RadarPainter(),
            ),
          ),
        );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          'Fart Detector',
          style: TextStyle(
            color: Color(0xFF2AB82D),
            fontSize: 22,
          ),
        ),
      ),
      centerTitle: true,
    );
  }
}