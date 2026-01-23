import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_shape/functions.dart';

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

recipe_card(String name){
  return GestureDetector(
    onTap: () {
      
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
          Text(name, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kcal', style: TextStyle(
                fontSize: 15
              ),),
              Text('Prot', style: TextStyle(
                fontSize: 15
              ),),
              Text('Carb', style: TextStyle(
                fontSize: 15
              ),),
              Text('Gord', style: TextStyle(
                fontSize: 15
              ),),
            ],
          ),
        ],
      ),
    )
  ); 
}

ingredient_card(String ingredient){
  return  Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Text(ingredient, style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kcal', style: TextStyle(
                fontSize: 15
              ),),
              Text('Prot', style: TextStyle(
                fontSize: 15
              ),),
              Text('Carb', style: TextStyle(
                fontSize: 15
              ),),
              Text('Gord', style: TextStyle(
                fontSize: 15
              ),),
            ],
          ),
        ],
      ),
    );
}

day_card(String day){
  return Container(
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
        Text(day, style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),),
        Text('Calorias: 923', style: TextStyle(
          fontSize: 18,
        ),)
      ],
    )
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

add_ingredient_form(BuildContext context){
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController kcalController = TextEditingController();
  final TextEditingController carbController = TextEditingController();
  final TextEditingController protController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
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
      Navigator.pop(context);
    } else {
      // algum campo cagou
      print('Form inválido');
    }
        }),
      ],
    ),
  );
}