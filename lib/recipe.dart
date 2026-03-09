import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/Recipes.dart';
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
  @override
  void initState() {
    super.initState();
    edited = false;
    Recipe = widget.Recipe;
  }

  update_recipe() async{
      Recipe = await Recipes().getByid(Recipe['id']);
      edited = true;
      setState(() {});
    }

  delete_recipe() async{
    await Recipes().delete(Recipe['id']);
    Navigator.pop(context, true);
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
            },)
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  titleText(Recipe['name']),
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
                  infoText('Fats:', Recipe['fats'].round().toString()),
                ],
              ),
              SizedBox(height: 10),
              Text('${Recipe['price'].toStringAsFixed(2)} R\$',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
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
      )
    );
  }
}