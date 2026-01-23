import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/functions.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.8,
          child: Column(children: [
            search_bar('Pesquisar'),
            recipe_card('Receita 1'),
            recipe_card('Receita 2'),
            recipe_card('Receita 3'),
            recipe_card('Receita 4'),
            recipe_card('Receita 5'),
          ],),
        ),
      ),
    );
  }
}

// Ingredients().insert('pimentão', 12.90, 56.90, 2.90, 2.09, 3.10);
// ElevatedButton(onPressed: () async{Ingredients().insert("batata", 23, 34, 84, 89, 87);}, child: Text("Teste"))
// Days().addConsumed('20260112', [['Receita', 1, 0.1], ['Ingrediente', 1, 0.5]]);