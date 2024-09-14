import 'package:fart_detector/radar_painter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          flex: 3,
          child: buildRadar(),
        ),
        Expanded(
          flex: 2,
          child: buildInfoPanel(),
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
        painter: RadarPainter(),
      ),
    );
  }

  Widget buildInfoPanel() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: const Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Range: 0m-5m',
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              '0m',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          'Fart Detector ver. 0.58',
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