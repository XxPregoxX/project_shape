import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';

class add_recipe extends StatefulWidget {
  const add_recipe({super.key});

  @override
  State<add_recipe> createState() => _add_recipeState();
}

class _add_recipeState extends State<add_recipe> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe Page'),
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.8,
          child: Column(
            children: [
              Icon(Icons.restaurant, size: 200),
              AddRecipeForm(),
            ],
          ),
        ),
      ),
    );
  }
}