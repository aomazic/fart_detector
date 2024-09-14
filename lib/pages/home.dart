import 'package:fart_detector/radar_painter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: RadarPainter(),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 350, // Adjust the height as needed
                color: Colors.black,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Test',
                      style: TextStyle(
                        color: Color(0xFF2AB82D),
                        fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add more Positioned widgets here for additional elements below the radar
          ],
        ),
      ),
    );
  }
}