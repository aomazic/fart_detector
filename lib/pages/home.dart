import 'package:fart_detector/radar_painter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dynamic values for info panel
  String threatLevel = 'Moderate';
  String detectionStatus = 'Active';
  String gasComposition = 'Methane 78%';
  String lastKnownFart = '1m South';

  // Console messages
  List<String> consoleMessages = ['Initializing...'];

  // Simulating a new fart detection
  void detectFart() {
    setState(() {
      consoleMessages.add('New Fart Detected!');
      threatLevel = 'High';
      detectionStatus = 'Detected at 3 o\'clock';
      gasComposition = 'Methane 95%';
      lastKnownFart = '2m West';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: detectFart, // Simulate a new detection on button press
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh),
      ),
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
        painter: RadarPainter(),
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
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: consoleMessages.length,
        itemBuilder: (context, index) {
          return Text(
            consoleMessages[index],
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
            ),
          );
        },
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
