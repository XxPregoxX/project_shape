import 'package:flutter/material.dart';
import 'package:project_shape/Recipes.dart';
import 'package:project_shape/Ingredients.dart';
import 'package:project_shape/days.dart';
import 'package:project_shape/profile.dart';

class MainLayout extends StatefulWidget {
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _index = 0;

  final pages = [
    recipes(),
    ingredients(),
    days(),
    profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _index,
              children: pages,
            ),
          ),

          // SUA BOTTOM BAR CUSTOM
          Container(
    height: 60,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 0, 0, 0),
      border: Border(
        top: BorderSide(color: Colors.white, width: 2),
      ),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
                _item(Icons.restaurant, 0, ),
                _item(Icons.eco, 1),
                _item(Icons.calendar_today, 2),
                _item(Icons.person, 3),
    ],
    ),
  ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() => _index = index);
      },
      child: Icon(
        icon,
        color: _index == index ? Colors.white : Colors.white38,
        size: 32,
      ),
    );
  }
}
