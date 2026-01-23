import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';

class add_ingredient extends StatefulWidget {
  const add_ingredient({super.key});

  @override
  State<add_ingredient> createState() => _add_ingredientState();
}

class _add_ingredientState extends State<add_ingredient> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth * 0.8,
          child: Column(
            children: [
              Icon(Icons.eco, size: 200),
              add_ingredient_form(context)
            ],
          ),
        ),
      ),
    );
  }
}