import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';

class days extends StatefulWidget {
  const days({super.key});

  @override
  State<days> createState() => _daysState();
}

class _daysState extends State<days> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.8,
          child: Column(children: [
            SizedBox(height: 40),
            day_card('2024-01-01'),
            day_card('2024-01-02'),
            day_card('2024-01-03'),
          ],),
        ),
      ),
    );
    
  }
}