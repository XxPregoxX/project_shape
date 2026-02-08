import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

search_bar(String hint){
           return Container(
            margin: const EdgeInsets.fromLTRB(0, 40, 0, 8),
             child: TextField(
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

recipe_card(BuildContext context, Map<String, dynamic> Recipe){
  String name = Recipe['name'];
  double calories = Recipe['calories']; 
  double protein = Recipe['protein'];
  double carbs = Recipe['carbs'];
  double fats = Recipe['fats'];
  double price = Recipe['price'];
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => recipe(Recipe: Recipe)));
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

ingredient_card(Map<String, dynamic> ingredient){
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
          Text('$name $price R\$', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
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
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => day(Day: cardDay)));
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
  List ingredients = await Ingredients().getAllNonDeleted();
  List recipes = await Recipes().getAllNonDeleted();
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
              if (_formKey.currentState!.validate()) {
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

day_grid(Map day){
  
  Widget gridblock(double child){ 
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Text(child.toString(), 
        style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
  }

  return Column(
    children: [
      Row(
        children: [
          gridblock(day['calories_goal']),
          gridblock(day['protein_goal']),
          gridblock(day['carbs_goal']),
          gridblock(day['fats_goal'])
        ],
      ),
      Row(
        children: [
          gridblock(day['calories_consumed']),
          gridblock(day['protein_consumed']),
          gridblock(day['carbs_consumed']),
          gridblock(day['fats_consumed'])
        ],
      ),
    ],
  );
}

general_textfield({ required String label, required TextEditingController controler, bool digitOnly = false }){
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

// isso tem que ser um stateful widget
add_ingredient_form(BuildContext context){
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController kcalController = TextEditingController();
  final TextEditingController carbController = TextEditingController();
  final TextEditingController protController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
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
  const AddRecipeForm({super.key});

  @override
  State<AddRecipeForm> createState() => _AddRecipeForm();
}

class _AddRecipeForm extends State<AddRecipeForm> {
  late Future<dynamic> _future;
  List selecteds = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController obsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = Ingredients().getAllNonDeleted();
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
        price += ingredientData[0]['price'] * fator;
        calories += ingredientData[0]['calories'] * fator;
        protein += ingredientData[0]['protein'] * fator;
        carbs += ingredientData[0]['carbs'] * fator;
        fats += ingredientData[0]['fats'] * fator;});
      ingredients[item.id] = double.parse(item.controller.text);
      };
      
      price = double.parse(price.toStringAsFixed(2));
      calories = double.parse(calories.toStringAsFixed(2));
      protein = double.parse(protein.toStringAsFixed(2)); 
      carbs = double.parse(carbs.toStringAsFixed(2));
      fats = double.parse(fats.toStringAsFixed(2));
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
  }) : controller = TextEditingController();
}


