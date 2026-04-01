import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/addRecipe.dart';
import 'package:project_shape/functions.dart';

class recipe extends StatefulWidget {
  final Map Recipe;
  const recipe({super.key, required this.Recipe});

  @override
  State<recipe> createState() => _recipeState();
}

class _recipeState extends State<recipe> {
  late Map Recipe;
  late bool edited;
  List ingredients = [];
  @override
  void initState() {
    super.initState();
    edited = false;
    Recipe = widget.Recipe;
  }

  Future<void> update_recipe() async{
      Recipe = await Recipes().getByid(Recipe['id']);
      await get_ingredients();
      edited = true;
      setState(() {});
    }

  Future<void> delete_recipe() async{
    await Recipes().delete(Recipe['id']);
    Navigator.pop(context, true);
  }

  Future<void> get_ingredients() async{
    ingredients = [];
    Map Decoded = jsonDecode(Recipe['ingredients']);
    for (String ingredientID in Decoded.keys){
      Map ingredient = await Ingredients().getByid(int.parse(ingredientID));
      List display = [ingredient['name'], Decoded[ingredientID]];
      ingredients.add(display);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, edited);
            },),
        actions: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                      onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => add_recipe(recipeData: Recipe))).then((value) async{
                        update_recipe();
                      });
                    }, icon: Icon(Icons.mode_edit,  color: Colors.white)),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                      onPressed: (){
                      delete_confirmation(context, delete_recipe);
                    }, icon: Icon(Icons.delete, color: Colors.white))
                  ],
                  ),
                ],
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                titleText(Recipe['name'], 30),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    infoText('kcal:', Recipe['calories'].round().toString()),
                    infoText('Prot:', Recipe['protein'].round().toString()),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    infoText('Carb:', Recipe['carbs'].round().toString()),
                    infoText('Gord:', Recipe['fats'].round().toString()),
                  ],
                ),
                SizedBox(height: 10),
                infoText('Custo:', '${Recipe['price'].toStringAsFixed(2)} R\$'),
                SizedBox(height: 15),
                FutureBuilder(future: get_ingredients(), builder: (context, snapshot){
                  return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      subtitleText('Ingredientes'),
                      for(List a in ingredients) Container(
                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(a[0], style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),),
                            Text('${a[1].round().toString()}g', style: TextStyle(
                              fontSize: 20,
                            ),)
                          ],
                        ),
                      ),
                    ]
                  ),
                );
                }),
                subtitleText('Descrição'),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(Recipe['description'],
                  style: const TextStyle(
                    fontSize: 17,
                  ),),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}