import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/addRecipe.dart';

class recipe extends StatefulWidget {
  final Map Recipe;
  const recipe({super.key, required this.Recipe});

  @override
  State<recipe> createState() => _recipeState();
}

class _recipeState extends State<recipe> {
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  titleText(widget.Recipe['name']),
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => add_recipe(recipeData: widget.Recipe))).then((value) {
                      if (value == true) {
                        setState(() {});
                      }
                    });
                  }, icon: Icon(Icons.mode_edit, color: Colors.white))
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoText('kcal:', widget.Recipe['calories'].round().toString()),
                  infoText('Prot:', widget.Recipe['protein'].round().toString()),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoText('Carb:', widget.Recipe['carbs'].round().toString()),
                  infoText('Fats:', widget.Recipe['fats'].round().toString()),
                ],
              ),
              SizedBox(height: 10),
              Text('${widget.Recipe['price'].toStringAsFixed(2)} R\$',
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
                child: Text(widget.Recipe['description'],
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