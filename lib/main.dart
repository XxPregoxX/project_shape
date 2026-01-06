import 'package:flutter/material.dart';
import 'package:project_shape/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu app',
      theme: ThemeData(
        useMaterial3: true, // verificar depois
      ),
      home: const HomePage(),
    );
  }
}