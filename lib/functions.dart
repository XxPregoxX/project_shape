import 'dart:convert';
import 'package:project_shape/db.dart';
import 'package:sqflite/sqflite.dart';

class Ingredients{

  insert(String name, double price, double calories, double proteins, double carbs, double fats)async{
    final db = await DatabaseHelper.database;
    await db.insert(
      'ingredients',
      {
        'name': name,
        'price': price,
        'calories': calories,
        'protein': proteins,
        'carbs': carbs,
        'fats': fats,
      }
    );
  }

  Future<void> update(int id, String name, double price, double calories, double proteins, double carbs, double fats) async{
    final db = await DatabaseHelper.database;
    await db.update(
      'ingredients',
      {
        'name': name,
        'price': price,
        'calories': calories,
        'protein': proteins,
        'carbs': carbs,
        'fats': fats,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async{
    final db = await DatabaseHelper.database;
    await db.update('ingredients',
    {
      'deleted': 1,
    },
    where: 'id = ?',
    whereArgs: [id],
    );
  }

  Future<void> restore(int id) async{
    final db = await DatabaseHelper.database;
    await db.update('ingredients',
    {
      'deleted': 0,
    },
    where: 'id = ?',
    whereArgs: [id],
    );
  }
  // função de testes
  getAll() async{
    final db = await DatabaseHelper.database;
    return await db.query('ingredients');
  }

}

class Meals{


  insert(String name, Map<int, double> ingredients, String description)async{
    final db = await DatabaseHelper.database;
    final mapStringKey = ingredients.map(
    (key, value) => MapEntry(key.toString(), value),
    );
    final jsoned = jsonEncode(mapStringKey);
    await db.insert(
      'meals',
      {
        'name': name,
        'ingredients': jsoned,
        'description': description,
      }
    );
  }

  Future<void> update(int id, String name, String ingredients, String description) async{
    final db = await DatabaseHelper.database;
    await db.update(
      'meals',
      {
        'name': name,
        'ingredients': ingredients,
        'description': description,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async{
    final db = await DatabaseHelper.database;
    await db.update('meals',
    {
      'deleted': 1,
    },
    where: 'id = ?',
    whereArgs: [id],
    );
  }

  Future<void> restore(int id) async{
    final db = await DatabaseHelper.database;
    await db.update('meals',
    {
      'deleted': 0,
    },
    where: 'id = ?',
    whereArgs: [id],
    );
  }

  // função de testes
  getAll() async{
    final db = await DatabaseHelper.database;
    return await db.query('meals');
    }
}

class Days{

  insert(String dayId, double costGoal, double caloriesGoal, double proteinGoal, double carbsGoal, double fatsGoal, String createdAt)async{
    final db = await DatabaseHelper.database;
    final now = DateTime.now();
    await db.insert(
      'days',
      {
        'day_id': dayId,
        'cost_goal': costGoal,
        'calories_goal': caloriesGoal,
        'protein_goal': proteinGoal,
        'carbs_goal': carbsGoal,
        'fats_goal': fatsGoal,
        'consumed': '',
        'created_at': now.toIso8601String(),
      }
    );
  }
  DateTime normalize(DateTime d) {
  return DateTime(d.year, d.month, d.day);
 }

 Daydiff(DateTime a, DateTime b) {
  a = normalize(a);
  b = normalize(b);
  return a.difference(b).inDays;
 }
add_days() async {
 if (await isTableEmpty()){
   String today = normalize(DateTime.now()).toString().split(' ').first.replaceAll('-', '');
   insert(today, 1, 1, 1, 1, 1, DateTime.now().toIso8601String()); // depois que tiver os goals ajustar aq
 } else {
    Map<String, dynamic>? lastDay = await getLastDay();
    DateTime lastDate = DateTime.parse(lastDay!['created_at']);
    int diff = Daydiff(DateTime.now(), lastDate);
    for (int i = 1; i <= diff; i++){
      DateTime newDate = lastDate.add(Duration(days: i));
      String dayId = normalize(newDate).toString().split(' ').first.replaceAll('-', '');
      insert(dayId, 1, 1, 1, 1, 1, newDate.toIso8601String()); // depois que tiver os goals ajustar aq
    }
 }
 return;
}

 Future<bool> isTableEmpty() async {
  final db = await DatabaseHelper.database;

  final result = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM days'),
  );

  return result == 0;
}

  getAll() async{
    final db = await DatabaseHelper.database;
    return await db.query('days');
    }

Future<Map<String, dynamic>?> getLastDay() async {
  final db = await DatabaseHelper.database;

  final result = await db.query(
    'days',
    orderBy: 'day_id DESC',
    limit: 1,
  );

  if (result.isEmpty) return null;
  return result.first;
}

  Future<void> addConsumed(String id, List<List> consumed) async{
    final db = await DatabaseHelper.database;
    await db.update('days',
    {
      'consumed': jsonEncode(consumed),
    },
    where: 'day_id = ?',
    whereArgs: [id],
    );
  }

} 