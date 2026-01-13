import 'package:flutter/material.dart';
import 'package:project_shape/functions.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(children: [
          ElevatedButton(onPressed: () async{Days().addConsumed('20260112', [['Receita', 1, 0.1], ['Ingrediente', 1, 0.5]]);}, child: Text("Teste")),
          ElevatedButton(onPressed: () async{print(await Days().getAll());}, child: Text("Verificar"))
        ],),
      ),
    );
  }
}

// Ingredients().insert('pimentão', 12.90, 56.90, 2.90, 2.09, 3.10);
// ElevatedButton(onPressed: () async{Ingredients().insert("batata", 23, 34, 84, 89, 87);}, child: Text("Teste"))