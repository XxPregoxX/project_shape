import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_shape/AddIngredient.dart';
import 'package:project_shape/day.dart';
import 'package:project_shape/functions.dart';
import 'package:project_shape/recipe.dart';

Widget titleText(String text) {
  return Text(
      text,
      textAlign: TextAlign.center,
      softWrap: true,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
}

Widget subtitleText(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
    child: Text(
      text,
      textAlign: TextAlign.center,
      softWrap: true,
      style: const TextStyle(
        fontSize: 22,
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

Widget search_bar(String hint, TextEditingController? controller){
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

Widget recipe_card(BuildContext context, Map<String, dynamic> Recipe, VoidCallback callback){
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
          callback(); 
        }
      }
      );
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 4),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF191919),
        borderRadius: BorderRadius.circular(8),
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

Future<void> delete_confirmation(BuildContext context, VoidCallback action){
 return  showDialog(
   context: context,
   builder: (_) {
     return Dialog(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text("Você tem certeza que deseja remover este item?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Não')),
            TextButton(onPressed: (){action(); Navigator.pop(context);}, child: Text('Sim'))
          ],)],
        ),
      ),
     );
   }
 );
}

Widget ingredient_card(BuildContext context, Map<String, dynamic> ingredient, [VoidCallback? onUpdate]) {
  String name = ingredient['name'];
  double calories = ingredient['calories']; 
  double protein = ingredient['protein'];
  double carbs = ingredient['carbs'];
  double fats = ingredient['fats'];
  double price = ingredient['price'];

  delete_ingredient(){
    Ingredients().delete(ingredient['id']);
    onUpdate!();
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
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text('$name', 
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  softWrap: true,),
                ),
                Column(
                  children: [
                    Row(children: [
                       IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => add_ingredient(ingredientData: ingredient))).then((value) {
                            if (onUpdate != null) {
                              onUpdate();
                          }
                        });
                      }, icon: Icon(Icons.mode_edit, color: Colors.white)),
                      IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          onPressed: (){
                            delete_confirmation(context, delete_ingredient);
                          }, icon: Icon(Icons.delete, color: Colors.white,))
                        ],),
                        Text('$price R\$', style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
            
                  ],
                ),
               
              ],
            ),
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

Widget goal_card(Map goal){
  double calories = goal['calories'];
  double protein = goal['protein'];
  double carbs = goal['carbs'];
  double fats = goal['fats'];
  double cost = goal['cost'];
  double weight = goal['weight'];
  String created_at = Profile().formatDate(goal['created_at']);
  return Container(
    padding: const EdgeInsets.fromLTRB(6, 2, 6, 6),
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white),
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Text(
            created_at,
            style: TextStyle(fontSize: 13),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Peso: ${weight.round()} KG', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(width: 20),
            Text('Orçamento: ${cost.round()} R\$', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
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

Widget day_card(context, Map<String, dynamic> cardDay, VoidCallback action){
  Map cardDayFix = Map.from(cardDay);
  cardDayFix['consumed'] = cardDayFix['consumed'] == '' ? [] : jsonDecode(cardDayFix['consumed'] as String);
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => day(Day: cardDayFix))).then((result){
        if (result == true){
          action();
        }
      });
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
          Text('Calorias: ${cardDay['calories_consumed'].round()}', style: TextStyle(
            fontSize: 18,
          ),)
        ],
      )
    ),
  );
}

Future<List> getIngredientsAndRecipes() async {
  List ingredientsRaw = await Ingredients().getAllNonDeleted();
  List ingredients = ingredientsRaw.map((item) => {...item, 'type': 'ingredient'}).toList();
  List recipesRaw = await Recipes().getAllNonDeleted();
  List recipes = recipesRaw.map((item) => {...item, 'type': 'recipe'}).toList();
  return ingredients + recipes;
}

Future<void> add_consumed(BuildContext context, String day_id, VoidCallback action) async{
  final result = await showDialog(context: context, builder: (_) => addConsumed(day_id: day_id));
  if (result == true) {
      action();
    }
}

class addConsumed extends StatelessWidget {
  addConsumed({super.key, required this.day_id});
  final String day_id;
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map selected = {};
  
  @override
  Widget build(BuildContext context) {
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
                      isExpanded: true,
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
                          child: Text(items[index]['name'], 
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                        );
                      }),
                        validator: (value) {
                          if (value == null) return 'Selecione um ingrediente';
                          return null;
                        },
                      onChanged: (value) {
                        selected.clear();
                        selected.addAll(items[value!]);
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
  }
}

Future<void> edit_profile(BuildContext context, VoidCallback action, [List? profileData]) async{
  final result = await showDialog(context: context, builder: (_) => editProfile(profileData: profileData,));
  if (result == true) {
      action();
    }
}

class editProfile extends StatelessWidget {
  editProfile({super.key, this.profileData})
        : nameController = TextEditingController(
          text: profileData != null ? profileData[0] : '',
        ),
        birthController = TextEditingController(
          text: profileData != null ? profileData[1] : '',
        ),
        heightController = TextEditingController(
          text: profileData != null ? profileData[2] : '',
        );

  final List? profileData;
  final TextEditingController nameController;
  final TextEditingController birthController;
  final TextEditingController heightController;
  final _formKey = GlobalKey<FormState>();

  String clean_date(String date) {
  String clean = date.replaceAll('/', '');
  return clean;
}

  @override
  Widget build(BuildContext context) {
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
              general_textfield(label: 'Nome', controler: nameController, limit: 30),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: date_picker(label: 'Data de Nascimento', controler: birthController, context: context)),
                    SizedBox(width: 10),
                    Expanded(child: general_textfield(label: 'Altura (cm)', controler: heightController, digitOnly: true, limit: 3)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextButton(onPressed: (){
                if (!(_formKey.currentState?.validate() ?? false)) {
                  return;
                }
                String name = nameController.text;
                String birth = clean_date(birthController.text);
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
  }
}

add_goal(BuildContext context, VoidCallback action) async{
  final result = await showDialog(context: context, builder: (_) => addGoal());
  if (result == true) {
    action();
  }
}

class addGoal extends StatelessWidget {
  addGoal({super.key});
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              split_textfield('Peso(KG)', 'Custo (R\$)', weightController, costController, 5),
              SizedBox(height: 20),
              split_textfield('Calorias', 'Proteínas (g)', caloriesController, proteinController, 5),
              SizedBox(height: 20),
              split_textfield('Carboidratos (g)', 'Gorduras (g)', carbsController, fatsController, 5),
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
  }
}

Widget day_grid(Map day){
  Widget gridblock(dynamic child){ 
    return Container(
      width: 100,
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

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text('Calorias'),
        Text('Proteinas'),
        Text('Carboidratos'),
        Text('Gorduras'),
        Text('Custo'),
      ],),
      Column(children: [
        Text('Meta'),
        gridblock(day['calories_goal'].round()),
        gridblock(day['protein_goal'].round()),
        gridblock(day['carbs_goal'].round()),
        gridblock(day['fats_goal'].round()),
        gridblock(day['cost_goal']),
      ],),
      Column(children: [
        Text('Consumido'),
        gridblock(day['calories_consumed'].round()),
        gridblock(day['protein_consumed'].round()),
        gridblock(day['carbs_consumed'].round()),
        gridblock(day['fats_consumed'].round()),
        gridblock(day['costs'])
      ],),
    ],
  );
}

Future<Widget> consumed_card(BuildContext context, List consumed, VoidCallback action) async {
  Map item;
  double factor = consumed[2] / 1000;
  if (consumed[0] == 'recipe' ){
    item = await Recipes().getByid(consumed[1]);
    factor = consumed[2] / item['weight'];
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
        Row(
          children: [
            Text('${item['name']} ${(item['price'] * factor).toStringAsFixed(2)} R\$', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
                        IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                onPressed: (){
                delete_confirmation(context, action);
              }, icon: Icon(Icons.delete, color: Colors.white,))
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kcal: ${(item['calories'] * factor).round()}', style: TextStyle(
              fontSize: 15
            ),),
            Text('Prot: ${(item['protein'] * factor).round()}', style: TextStyle(
              fontSize: 15
            ),),
            Text('Carb: ${(item['carbs'] * factor).round()}', style: TextStyle(
              fontSize: 15
            ),),
            Text('Gord: ${(item['fats'] * factor).round()}', style: TextStyle(
              fontSize: 15
            ),),
          ],
        ),
      ],
    ),
  );
}

Widget general_textfield({required String label, required TextEditingController controler, bool digitOnly = false, int limit = 0}){

  List<TextInputFormatter> formaters = [];
  if (digitOnly){
    formaters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')));
  }
  if (limit > 0){
    formaters.add(LengthLimitingTextInputFormatter(limit));
  }
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
    inputFormatters: formaters,
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

date_picker({required String label, required TextEditingController controler,required BuildContext context}){
  if (controler.text.isNotEmpty){
  String dia = controler.text.substring(0, 2);
  String mes = controler.text.substring(2, 4);
  String ano = controler.text.substring(4, 8);
  controler.text = '$dia/$mes/$ano';
  }
  return TextField(
  readOnly: true,
  controller: controler,
  onTap: () async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      String data =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
      controler.text = data;
    }
  },
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

Widget value_textfield({ required String label, required TextEditingController controler, int? limit}){
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
    maxLength: limit,
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
    counterText: '',
    ),
  );
}
Widget split_textfield(String label1, String label2, TextEditingController controler1, TextEditingController controller2, [int limit = 0]){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(child: general_textfield(label: label1, controler:  controler1, digitOnly: true, limit: limit)),
      SizedBox(width: 40),
      Expanded(child: general_textfield(label: label2, controler:  controller2, digitOnly: true, limit: limit)),
    ],
  );
}

Widget confirmar_button(String text, VoidCallback onPressed){
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

class addIngredientForm extends StatelessWidget {
  addIngredientForm({super.key, this.ingredientData})
    : nameController = TextEditingController(
          text: ingredientData?['name'] ?? ''),
      kcalController = TextEditingController(
          text: ingredientData?['calories']?.round().toString() ?? ''),
      carbController = TextEditingController(
          text: ingredientData?['carbs']?.round().toString() ?? ''),
      protController = TextEditingController(
          text: ingredientData?['protein']?.round().toString() ?? ''),
      fatController = TextEditingController(
          text: ingredientData?['fats']?.round().toString() ?? ''),
      priceController = TextEditingController(
          text: ingredientData?['price']?.round().toString() ?? '');

  final Map<String, dynamic>? ingredientData;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController;
  final TextEditingController kcalController;
  final TextEditingController carbController;
  final TextEditingController protController;
  final TextEditingController fatController;
  final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    return Form(
    key: _formKey,
    child: Column(
      children: [
        general_textfield(label: 'Nome do ingrediente', controler: nameController, limit: 40),
        SizedBox(height: 20),
        split_textfield('Kcal', 'Carboidratos (g)', kcalController, carbController, 4),
        SizedBox(height: 20),
        split_textfield('Proteínas (g)', 'Gorduras (g)', protController, fatController, 4),
        SizedBox(height: 20),
        general_textfield(label: 'Preço (P/Kg)', controler:  priceController, digitOnly: true, limit: 5),
        SizedBox(height: 20),
        confirmar_button('Confirmar', () {
          if (_formKey.currentState!.validate()) {
            double kcal = double.parse(kcalController.text);
            double carb = double.parse(carbController.text);
            double prot = double.parse(protController.text);
            double fat = double.parse(fatController.text);
            double price = double.parse(priceController.text);
            String name = nameController.text;
            if (ingredientData != null) {
              Ingredients().update(ingredientData!['id'], name, price, kcal, prot, carb, fat).then((_) {
                Navigator.pop(context, true);
              });
              return;
            }
            Ingredients().insert(name, price, kcal, prot, carb, fat);
            Navigator.pop(context, true);
          }
        }),
      ],
    ),
  );
  }
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
          general_textfield(label: 'Nome da receita', controler: nameController, limit: 30),
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
                  color: Colors.white,
                  width: 1,
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
        isExpanded: true,
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
            child: Text(
              ingredients[index]['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              ),
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

Widget ingredient_added_row(String name, TextEditingController controller, size){
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(name, 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, 
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
            ),
          ),
          SizedBox(
            width: size,
            height: 45,
            child: value_textfield(label: 'Peso (g)', controler: controller, limit: 4),
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


