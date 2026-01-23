import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';

class ingredients extends StatefulWidget {
  const ingredients({super.key});

  @override
  State<ingredients> createState() => _ingredientsState();
}

class _ingredientsState extends State<ingredients> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
                child: SizedBox(
          width: screenWidth * 0.8,
          child: Column(children: [
            search_bar('Pesquisar'),
            ingredient_card('banana')
          ],),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, '/add_ingredient');
      }, child: Icon(Icons.add),
    ),
    );
  }
}