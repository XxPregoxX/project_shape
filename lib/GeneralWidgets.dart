import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_shape/AddIngredient.dart';
import 'package:project_shape/Ingredients.dart';
import 'package:project_shape/day.dart';
import 'package:project_shape/functions.dart';
import 'package:project_shape/recipe.dart';

Widget titleText(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget infoText(String label, String value) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
      children: [
        TextSpan(
          text: '$label ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: value,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

search_bar(String hint, TextEditingController? controller){
           return Container(
            margin: const EdgeInsets.fromLTRB(0, 40, 0, 8),
             child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: hint,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              prefixIcon: Icon(Icons.search),
              ),
              ),
           );
}

recipe_card(BuildContext context, Map<String, dynamic> Recipe, VoidCallback callback){
  String name = Recipe['name'];
  double calories = Recipe['calories']; 
  double protein = Recipe['protein'];
  double carbs = Recipe['carbs'];
  double fats = Recipe['fats'];
  double price = Recipe['price'];
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => recipe(Recipe: Recipe))).then((result){
        if (result == true){
          print('teste');
          callback(); 
        }
      }
      );
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 3),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF191919),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Text('$name $price R\$', style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kcal: ${calories.round()}', style: TextStyle(
                fontSize: 15
              ),),
              Text('Prot: ${protein.round()}', style: TextStyle(
                fontSize: 15
              ),),
              Text('Carb: ${carbs.round()}', style: TextStyle(
                fontSize: 15
              ),),
              Text('Gord: ${fats.round()}', style: TextStyle(
                fontSize: 15
              ),),
            ],
          ),
        ],
      ),
    )
  ); 
}

ingredient_card(BuildContext context, Map<String, dynamic> ingredient, [VoidCallback? onUpdate]) {
  String name = ingredient['name'];
  double calories = ingredient['calories']; 
  double protein = ingredient['protein'];
  double carbs = ingredient['carbs'];
  double fats = ingredient['fats'];
  double price = ingredient['price'];
  return  Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('$name $price R\$', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => add_ingredient(ingredientData: ingredient))).then((value) {
                  if (onUpdate != null) {
                    onUpdate();
                  }
                });
              }, icon: Icon(Icons.mode_edit, color: Colors.white))
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kcal: ${calories.round()}', style: TextStyle(
                fontSize: 15
              ),),
              Text('Prot: ${protein.round()}', style: TextStyle(
                fontSize: 15
              ),),
              Text('Carb: ${carbs.round()}', style: TextStyle(
                fontSize: 15
              ),),
              Text('Gord: ${fats.round()}', style: TextStyle(
                fontSize: 15
              ),),
            ],
          ),
        ],
      ),
    );
}

  day_card(context, Map<String, dynamic> cardDay){
    Map cardDayFix = Map.from(cardDay);
    cardDayFix['consumed'] = cardDayFix['consumed'] == '' ? [] : jsonDecode(cardDayFix['consumed'] as String);
    return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => day(Day: cardDayFix)));
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF323232),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Days().dayIdToDate(cardDay['day_id']), style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),),
          Text('Calorias: 923', style: TextStyle(
            fontSize: 18,
          ),)
        ],
      )
    ),
  );
}

getIngredientsAndRecipes() async {
  List ingredientsRaw = await Ingredients().getAllNonDeleted();

  List ingredients = ingredientsRaw.map((item) => {...item, 'type': 'ingredient'}).toList();
  List recipesRaw = await Recipes().getAllNonDeleted();
  List recipes = recipesRaw.map((item) => {...item, 'type': 'recipe'}).toList();
  return ingredients + recipes;
}

AddConsumed(BuildContext context, String day_id) {
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map selected = {};
  

  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text('Nome'),
        content: FutureBuilder(future: getIngredientsAndRecipes(), builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro ao carregar ingredientes e receitas');
          } else {
            List items = snapshot.data as List;
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Selecione',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    items: List.generate(items.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(items[index]['name']),
                      );
                    }),
                      validator: (value) {
                        if (value == null) return 'Selecione um ingrediente';
                        return null;
                      },
                    onChanged: (value) {
                      selected = items[value!];
                    },
                  ),
                  general_textfield(label: 'Quantidade (g)', controler: controller)
                ],
              ),
            );
          }
        }),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                Days().addConsumed(day_id, selected, double.parse(controller.text)).then((_) {
                  Navigator.pop(context, true);
                });
              }
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

// isso tmb tem que ser un stateless widget
edit_profile(BuildContext context, [List? profileData]) {
  TextEditingController nameController = TextEditingController(text: profileData != null ? profileData[0] : '');
  TextEditingController birthController = TextEditingController(text: profileData != null ? profileData[1] : '');
  TextEditingController heightController = TextEditingController(text: profileData != null ? profileData[2] : '');
  final _formKey = GlobalKey<FormState>();
  return showDialog(context: context, builder: (context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      backgroundColor: Color(0xFF191919),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Editar Perfil'),
              SizedBox(height: 20),
              general_textfield(label: 'Nome', controler: nameController),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: general_textfield(label: 'Nascimento', controler: birthController, digitOnly: true)),
                    SizedBox(width: 10),
                    Expanded(child: general_textfield(label: 'Altura (cm)', controler: heightController, digitOnly: true)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextButton(onPressed: (){
                if (!(_formKey.currentState?.validate() ?? false)) {
                  return;
                }
                String name = nameController.text;
                String birth = birthController.text;
                double height = double.parse(heightController.text);
                Profile().update(name, height, birth).then((_) {
                  Navigator.pop(context, true);
                });
              }, child: Text('Confirmar'))
            ],
          ),
        )
      ),
    );
  });
}

add_goal(BuildContext context){
  TextEditingController caloriesController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatsController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  return showDialog(context: context, builder: (context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      backgroundColor: Color(0xFF191919),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Adicionar Meta'),
              SizedBox(height: 20),
              split_textfield('Peso(KG)', 'Custo (R\$)', weightController, costController),
              SizedBox(height: 20),
              split_textfield('Calorias', 'Proteínas (g)', caloriesController, proteinController),
              SizedBox(height: 20),
              split_textfield('Carboidratos (g)', 'Gorduras (g)', carbsController, fatsController),
              SizedBox(height: 20),
              TextButton(onPressed: (){
                if (!(_formKey.currentState?.validate() ?? false)) {
                  return;
                }
                double calories = double.parse(caloriesController.text);
                double protein = double.parse(proteinController.text);
                double carbs = double.parse(carbsController.text);
                double fats = double.parse(fatsController.text);
                double cost = double.parse(costController.text);
                double weight = double.parse(weightController.text);
                Profile().goalInsert(weight, calories, protein, carbs, fats, cost).then((_) {
                  Navigator.pop(context, true);
                });
              }, child: Text('Confirmar'))
            ],
          ),
        )
      ),
    );
  });
}

Widget goal_card(Map goal){
  double calories = goal['calories'];
  double protein = goal['protein'];
  double carbs = goal['carbs'];
  double fats = goal['fats'];
  double cost = goal['cost'];
  double weight = goal['weight'];
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${weight.round()} KG', style: TextStyle(
              fontSize: 15
            ),),
            SizedBox(width: 20),
            Text('Gasto: ${cost.round()} R\$', style: TextStyle(
              fontSize: 15
            ),),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kcal: ${calories.round()}', style: TextStyle(
              fontSize: 15
            ),),
            Text('Prot: ${protein.round()}', style: TextStyle(
              fontSize: 15
            ),),
            Text('Carb: ${carbs.round()}', style: TextStyle(
              fontSize: 15
            ),),
            Text('Gord: ${fats.round()}', style: TextStyle(
              fontSize: 15
            ),),
          ],
        ),
      ],
    ),
  );
}

day_grid(Map day){
  Widget gridblock(dynamic child){ 
    return Container(
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Text(child.toString(), 
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
  }

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          gridblock(day['calories_goal'].round()),
          gridblock(day['protein_goal'].round()),
          gridblock(day['carbs_goal'].round()),
          gridblock(day['fats_goal'].round()),
          gridblock(day['cost_goal'])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          gridblock(day['calories_consumed'].round()),
          gridblock(day['protein_consumed'].round()),
          gridblock(day['carbs_consumed'].round()),
          gridblock(day['fats_consumed'].round()),
          gridblock(day['costs'])
        ],
      ),
    ],
  );
}

consumed_card(List consumed) async {
  Map item;
  if (consumed[0] == 'recipe' ){
    item = await Recipes().getByid(consumed[1]);
  }
  else {
    item = await Ingredients().getByid(consumed[1]);
  }
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white),
    ),
    child: Column(
      children: [
        Text('${item['name']} ${item['price']} R\$', style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kcal: ${item['calories'].round()}', style: TextStyle(
              fontSize: 15
            ),),
            Text('Prot: ${(item['protein']).round()}', style: TextStyle(
              fontSize: 15
            ),),
            Text('Carb: ${item['carbs'].round()}', style: TextStyle(
              fontSize: 15
            ),),
            Text('Gord: ${item['fats'].round()}', style: TextStyle(
              fontSize: 15
            ),),
          ],
        ),
      ],
    ),
  );
}

general_textfield({ required String label, required TextEditingController controler, bool digitOnly = false}){
  return TextFormField(
    controller: controler,
    validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }else if (digitOnly && double.tryParse(value) == null) {
            return 'Campo deve ser numérico';
          }
          return null;
          },
    keyboardType: digitOnly ? TextInputType.number : TextInputType.text,
    inputFormatters: digitOnly ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))] : null,
    decoration: InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

value_textfield({ required String label, required TextEditingController controler}){
  return TextFormField(
    controller: controler,
    validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }else if (double.tryParse(value) == null) {
            return 'Campo deve ser numérico';
          }
          return null;
          },
    keyboardType:TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
    decoration: InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(3),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(3),
      ),
      contentPadding: EdgeInsets.symmetric(
      horizontal: 3,
      vertical: 5,
    ),
    ),
  );
}

split_textfield(String label1, String label2, TextEditingController controler1, TextEditingController controller2){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(child: general_textfield(label: label1, controler:  controler1, digitOnly: true)),
      SizedBox(width: 40),
      Expanded(child: general_textfield(label: label2, controler:  controller2, digitOnly: true)),
    ],
  );
}

confirmar_button(String text, VoidCallback onPressed){
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      side: BorderSide(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    child: Text(text, style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),),
  );
}

// isso tem que ser um stateless widget
add_ingredient_form(BuildContext context, [Map<String, dynamic>? ingredientData]) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(text: ingredientData != null ? ingredientData['name'] : '');
  final TextEditingController kcalController = TextEditingController(text: ingredientData != null ? ingredientData['calories'].round().toString() : '');
  final TextEditingController carbController = TextEditingController(text: ingredientData != null ? ingredientData['carbs'].round().toString() : '');
  final TextEditingController protController = TextEditingController(text: ingredientData != null ? ingredientData['protein'].round().toString() : '');
  final TextEditingController fatController = TextEditingController(text: ingredientData != null ? ingredientData['fats'].round().toString() : '');
  final TextEditingController priceController = TextEditingController(text: ingredientData != null ? ingredientData['price'].toString() : '');
  // Todos os controllers acime não estão sendo descartados, o que pode causar memory leaks em uso prolongado.
  return Form(
    key: _formKey,
    child: Column(
      children: [
        general_textfield(label: 'Nome do ingrediente', controler: nameController),
        SizedBox(height: 20),
        split_textfield('Kcal', 'Carboidratos (g)', kcalController, carbController),
        SizedBox(height: 20),
        split_textfield('Proteínas (g)', 'Gorduras (g)', protController, fatController),
        SizedBox(height: 20),
        general_textfield(label: 'Preço (Kg)', controler:  priceController, digitOnly: true),
        SizedBox(height: 20),
        confirmar_button('Confirmar', () {
          if (_formKey.currentState!.validate()) {
      // tudo válido
      double kcal = double.parse(kcalController.text);
      double carb = double.parse(carbController.text);
      double prot = double.parse(protController.text);
      double fat = double.parse(fatController.text);
      double price = double.parse(priceController.text);
      String name = nameController.text;
      if (ingredientData != null) {
        Ingredients().update(ingredientData['id'], name, price, kcal, prot, carb, fat).then((_) {
          Navigator.pop(context, true);
        });
        return;
      }
      Ingredients().insert(name, price, kcal, prot, carb, fat);
      Navigator.pop(context, true);
    } else {
      print('Form inválido');
    }
        }),
      ],
    ),
  );
}

class AddRecipeForm extends StatefulWidget {
  final Map? recipeData;
  const AddRecipeForm({super.key, this.recipeData});

  @override
  State<AddRecipeForm> createState() => _AddRecipeForm();
}

class _AddRecipeForm extends State<AddRecipeForm> {
  late Future<dynamic> _future;
  List selecteds = [];
  late TextEditingController nameController;
  late TextEditingController obsController;
  late int id;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    _future = Ingredients().getAllNonDeleted();

    nameController = TextEditingController(
    text: widget.recipeData != null
        ? widget.recipeData!['name']
        : '',
    );
    obsController = TextEditingController(
      text: widget.recipeData != null
          ? widget.recipeData!['description']
          : '',
    );
    if (widget.recipeData != null) {
      edit = true;
      id = widget.recipeData!['id'];
      Map ingredients = jsonDecode(widget.recipeData!['ingredients']);
      ingredients.forEach((key, value) async{
        Map ingredient = await Ingredients().getByid(int.parse(key));
        select_ingredient(SelectedIngredient(id: int.parse(key), name: ingredient['name'], controller: TextEditingController(text: value.round().toString())));
      });
    }
  }

  void reload() {
    setState(() {
      _future = Ingredients().getAllNonDeleted();
    });
  }

  void select_ingredient(SelectedIngredient valor) {
    if (!selecteds.any((e) => e.id == valor.id)) {
      setState(() {
        selecteds.add(valor);
      });
    }
  }

  void submit_recipe(String name, String Observation) async{
      Map<int, double> ingredients = {};
      double price = 0;
      double calories = 0;
      double protein = 0;
      double carbs = 0;
      double fats = 0;
      for (final item in selecteds){
      double fator = int.parse(item.controller.text) / 1000;
      await Ingredients().getByid(item.id).then((ingredientData) {
        price += ingredientData['price'] * fator;
        calories += ingredientData['calories'] * fator;
        protein += ingredientData['protein'] * fator;
        carbs += ingredientData['carbs'] * fator;
        fats += ingredientData['fats'] * fator;});
      ingredients[item.id] = double.parse(item.controller.text);
      };
      
      price = double.parse(price.toStringAsFixed(2));
      calories = double.parse(calories.toStringAsFixed(2));
      protein = double.parse(protein.toStringAsFixed(2)); 
      carbs = double.parse(carbs.toStringAsFixed(2));
      fats = double.parse(fats.toStringAsFixed(2));
      if (edit){
        await Recipes().update(id, name, ingredients, Observation, price, calories, protein, carbs, fats);
        Navigator.pop(context, true);
        return;
      }
      await Recipes().insert(name, ingredients, Observation, price, calories, protein, carbs, fats);
      Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();


    return Form(
      key: _formKey,
      child: Column(
        children: [
          general_textfield(label: 'Nome da receita', controler: nameController),
          SizedBox(height: 20),
          FutureBuilder(future: _future, builder: 
          (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
          } 

          dynamic ingredientes = snapshot.data!;
          return Column(
          children: [
          GeneralDropdown(onAddIngredient: (valor) => select_ingredient(valor), ingredients: ingredientes),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white, // cor da borda
                  width: 1,            // espessura
                ),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.15,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...selecteds.map((e) => ingredient_added_row(e.name, e.controller, MediaQuery.of(context).size.width * 0.2)).toList(),
                ],
              ),
            )
            ,
          )
          
            ],);
          }),
          SizedBox(height: 20),
          Container(child: TextFormField(
            controller: obsController,
            maxLines: 7,
            decoration: InputDecoration(
              labelText: 'Observações',
              alignLabelWithHint: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
            )
          ),),
          SizedBox(height: 20),
          confirmar_button('Confirmar', () {
            if (selecteds.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Adicione pelo menos um ingrediente'),
                ),
              );
              return;
            }
            if (_formKey.currentState!.validate()) {
              // tudo válido
              submit_recipe(nameController.text, obsController.text);
            } 

          }),
        ],
      ),
    );
  }
}


class GeneralDropdown extends StatelessWidget {
  final void Function(SelectedIngredient valor) onAddIngredient;
  final List ingredients;

  GeneralDropdown({required this.onAddIngredient, required this.ingredients});


    Widget build(BuildContext context){
      int ingredients_number = ingredients.length;
      return Column(
      children: [
        DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: 'Ingrediente',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        items: List.generate(ingredients_number, (index) {
          return DropdownMenuItem<int>(
            value: index,
            child: Text(ingredients[index]['name']),
          );
        }),
        onChanged: (value) {
          onAddIngredient(SelectedIngredient(id: ingredients[value!]['id'], name: ingredients[value]['name']));
        },
          ),
      ],
    );
}
}

ingredient_added_row(String name, TextEditingController controller, size){
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(name, style: TextStyle(
              fontSize: 20,
            ),),
          ),
          SizedBox(
            width: size,
            height: 45,
            child: value_textfield(label: 'Peso (g)', controler: controller),
          ),
        ],
      ),
  );
}

class SelectedIngredient {
  final int id;
  final String name;
  final TextEditingController controller;

  SelectedIngredient({
    required this.id,
    required this.name,
    TextEditingController? controller,
  }) : controller = controller ?? TextEditingController();
}


