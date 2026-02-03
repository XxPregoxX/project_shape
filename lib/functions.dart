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

  Future<List<Map<String, dynamic>>> fetchIngredients({
  required int limit,
  required int offset,
}) async {
  final db = await DatabaseHelper.database;

  return await db.query(
    'ingredients',
    orderBy: 'id',
    limit: limit,
    offset: offset,
  );
}

getAllNonDeleted() async{
    final db = await DatabaseHelper.database;
    return await db.query('ingredients', where: 'deleted = 0');
  }

  getByid(int id) async{
    final db = await DatabaseHelper.database;
    return await db.query(
    'ingredients',
    where: 'id = $id',
  );
  }

}

class Recipes{


  insert(String name, Map<int, double> ingredients, String description, double price, double calories, double protein, double carbs, double fats)async{
    final db = await DatabaseHelper.database;
    final mapStringKey = ingredients.map(
    (key, value) => MapEntry(key.toString(), value),
    );
    final jsoned = jsonEncode(mapStringKey);
    await db.insert(
      'recipes',
      {
        'name': name,
        'ingredients': jsoned,
        'price': price, 
        'calories': calories, 
        'protein': protein, 
        'carbs': carbs, 
        'fats': fats,
        'description': description,
      }
    );
  }

  Future<void> update(int id, String name, String ingredients, String description, double price, double calories, double protein, double carbs, double fats) async{
    final db = await DatabaseHelper.database;
    await db.update(
      'recipes',
      {
        'name': name,
        'ingredients': ingredients,
        'price': price, 
        'calories': calories, 
        'protein': protein, 
        'carbs': carbs, 
        'fats': fats,
        'description': description,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async{
    final db = await DatabaseHelper.database;
    await db.update('recipes',
    {
      'deleted': 1,
    },
    where: 'id = ?',
    whereArgs: [id],
    );
  }

  Future<void> restore(int id) async{
    final db = await DatabaseHelper.database;
    await db.update('recipes',
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
    return await db.query('recipes');
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
 Map<String, dynamic>? goals = await Profile().getCurrentGoals();
 if (goals == null) return;
 if (await isTableEmpty()){
   String today = normalize(DateTime.now()).toString().split(' ').first.replaceAll('-', '');
   insert(today, goals['cost'], goals['calories'], goals['protein'], goals['carbs'], goals['fats'], DateTime.now().toIso8601String()); // depois que tiver os goals ajustar aq
 } else {
    Map<String, dynamic>? lastDay = await getLastDay();
    DateTime lastDate = DateTime.parse(lastDay!['created_at']);
    int diff = Daydiff(DateTime.now(), lastDate);
    for (int i = 1; i <= diff; i++){
      DateTime newDate = lastDate.add(Duration(days: i));
      String dayId = normalize(newDate).toString().split(' ').first.replaceAll('-', '');
      insert(dayId, goals['cost'], goals['calories'], goals['protein'], goals['carbs'], goals['fats'], newDate.toIso8601String()); // depois que tiver os goals ajustar aq
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

  class Profile{
  insert(String name, double height, String birthDate)async{
    final db = await DatabaseHelper.database;
    await db.insert(
      'profile',
      {
        'id': 1, // id do usuario sempre 1 pq so tem 1 perfil
        'name': name,
        'height': height,
        'birth_date': birthDate,
      }
    );
  }

  Future<void> update(String name, double height, String birthDate) async{
    final db = await DatabaseHelper.database;
    await db.update(
      'profile',
      {
        'name': name,
        'height': height,
        'birth_date': birthDate,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  goalInsert(double cost, double calories, double protein, double carbs, double fats) async {
    final db = await DatabaseHelper.database;
    final now = DateTime.now();
    await db.insert(
      'goals',
      {
        'cost': cost,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'created_at': now.toIso8601String(),
      }
    );
  }
  getCurrentGoals() async {
    final db = await DatabaseHelper.database;
    final result = await db.query(
      'goals',
      orderBy: 'created_at DESC',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first;
  }
}