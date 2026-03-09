import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/functions.dart';

class ingredients extends StatefulWidget {
  const ingredients({super.key});

  @override
  State<ingredients> createState() => _ingredientsState();
}

class _ingredientsState extends State<ingredients> {
    List<Map<String, dynamic>> ingredients = [];
    int limit = 10;
    int offset = 0;
    bool isLoading = false;
    bool hasMore = true;
    late TextEditingController searchController;
    final ScrollController _controller = ScrollController();

    Future<void> Update() async {
      ingredients = await Ingredients().getIngredients(
        search: searchController.text
      );
      setState(() {});
    }


    @override
    void initState() {
      super.initState();
      searchController = TextEditingController();
      Update();
      searchController.addListener((){
        Update();
      });
    }


    Future<void> goToAddIngredient() async {
    final result = await Navigator.pushNamed(context, '/add_ingredient');
    if (result == true) {
      Update();
    }
    }

    build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
          width: screenWidth * 0.8,
          child: Column(children: [
            search_bar('Pesquisar Ingrediente', searchController),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                    final item = ingredients[index];
                    return ingredient_card(context, item, () {
                      Update();
                    });

                },
              ),
            ),
          ],),
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 50,
        child: FloatingActionButton(onPressed: (){
          goToAddIngredient();
        }, 
        child: Icon(Icons.add),
        shape: CircleBorder(),
            ),
      ),
    );
  }
}