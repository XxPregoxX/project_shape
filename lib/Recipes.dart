import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/functions.dart';


class recipes extends StatefulWidget {
  const recipes({super.key});

  @override
  State<recipes> createState() => _recipesState();
}

class _recipesState extends State<recipes> {

  Future<void> goToAddRecipe() async {
    final result = await Navigator.pushNamed(context, '/add_recipe');
    if (result == true) {
      setState(() {});
    }
    }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.8,
          child: Column(children: [
            search_bar('Pesquisar'),
            Expanded(
                child: FutureBuilder(future: Recipes().getAllNonDeleted(), builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError){
                    return Center(child: Text('Erro ao carregar receitas'));
                  } else {
                    List<Map<String, dynamic>> recipes = snapshot.data as List<Map<String, dynamic>>;
                    return ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final item = recipes[index];
                        return recipe_card(context, item);
                      },
                    );
                  }
                })
              ),
          ],),
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 50,
        child: FloatingActionButton(onPressed: (){
          goToAddRecipe();
        }, 
        child: Icon(Icons.add),
        shape: CircleBorder(),
        heroTag: null,
            ),
      ),
    );
  }
}

// Ingredients().insert('pimentão', 12.90, 56.90, 2.90, 2.09, 3.10);
// ElevatedButton(onPressed: () async{Ingredients().insert("batata", 23, 34, 84, 89, 87);}, child: Text("Teste"))
// Days().addConsumed('20260112', [['Receita', 1, 0.1], ['Ingrediente', 1, 0.5]]);