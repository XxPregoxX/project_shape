import 'package:flutter/material.dart';
import 'package:project_shape/AddIngredient.dart';
import 'package:project_shape/HomePage.dart';
import 'package:project_shape/Ingredients.dart';
import 'package:project_shape/Page.dart';
import 'package:project_shape/addRecipe.dart';
import 'package:project_shape/days.dart';
import 'package:project_shape/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu app',
      theme: ThemeData(
      colorScheme: const ColorScheme.dark(
      surface: Colors.black,
      primary: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: true, // verificar depois
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainLayout(),
        '/meals': (context) => HomePage(),  
        '/add_recipe': (context) => add_recipe(),
        '/ingredients': (context) => ingredients(),
        '/add_ingredient': (context) => add_ingredient(),
        '/days': (context) => days(),
        '/profile': (context) => profile(),
      },
    );
  }
}