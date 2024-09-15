import 'package:fart_detector/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'pcsenior',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF2AB82D)),
          bodyMedium: TextStyle(color: Color(0xFF2AB82D)),
        ),
      ),
      home: HomePage(),
    );
  }
}
