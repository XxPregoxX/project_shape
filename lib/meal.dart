import 'package:flutter/material.dart';

class meal extends StatefulWidget {
  const meal({super.key});

  @override
  State<meal> createState() => _mealState();
}

class _mealState extends State<meal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Page'),
      ),
      body: Center(
        child: Text('This is the meal page.'),
      ),
    );
  }
}