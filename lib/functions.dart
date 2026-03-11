import 'dart:convert';
import 'package:project_shape/db.dart';
import 'package:sqflite/sqflite.dart';

class Ingredients{

  Future<void> insert(String name, double price, double calories, double proteins, double carbs, double fats)async{
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

  Future<List<Map<String, dynamic>>> getIngredients({
  String? search
  }) async {
  final db = await DatabaseHelper.database;
  String where = 'deleted = ?';
  List whereArgs = [0];
  if (search != null && search.trim().isNotEmpty) {
    where += ' AND name LIKE ?';
    whereArgs.add('%$search%');
  }

  return await db.query(
    'ingredients',
    orderBy: 'id',
    where: where,
    whereArgs: whereArgs
  );
  }

  Future<List<Map<String, dynamic>>> getAllNonDeleted() async{
    final db = await DatabaseHelper.database;
    return await db.query('ingredients', 
    where: 'deleted = ?',
    whereArgs: [0]);
  }

  Future<Map<String, dynamic>> getByid(int id) async{
    final db = await DatabaseHelper.database;
    final result = await db.query(
    'ingredients',
    where: "id = ?",
    whereArgs: [id]
    );
    return Map.from(result.first);
  }

}

class Recipes{


  Future<void> insert(String name, Map<int, double> ingredients, String description, double price, double calories, double protein, double carbs, double fats)async{
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
        'weight': mapStringKey.values.reduce((a, b) => a + b),
        'price': price, 
        'calories': calories, 
        'protein': protein, 
        'carbs': carbs, 
        'fats': fats,
        'description': description,
      }
    );
  }

  Future<void> update(int id, String name, Map<int, double> ingredients, String description, double price, double calories, double protein, double carbs, double fats) async{
    final db = await DatabaseHelper.database;
    final mapStringKey = ingredients.map(
    (key, value) => MapEntry(key.toString(), value),
    );
    final jsoned = jsonEncode(mapStringKey);
    await db.update(
      'recipes',
      {
        'name': name,
        'ingredients': jsoned,
        'weight': mapStringKey.values.reduce((a, b) => a + b),
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

  Future<Map<String, Object?>>getByid(int id) async{
    final db = await DatabaseHelper.database;
    final result = await db.query(
    'recipes',
    where: "id = ?",
    whereArgs: [id]
    );
    return Map.from(result.first);
  }

  Future<List<Map<String, dynamic>>> getRecipes({
  String? search
  }) async {
  final db = await DatabaseHelper.database;
  String where = 'deleted = ?';
  List whereArgs = [0];

  if (search != null && search.trim().isNotEmpty) {
    where += ' AND name LIKE ?';
    whereArgs.add('%$search%');
  }

  return await db.query(
    'recipes',
    orderBy: 'id',
    where: where,
    whereArgs: whereArgs
  );
  }

  Future<List<Map<String, Object?>>> getAllNonDeleted() async{
    final db = await DatabaseHelper.database;
    return await db.query('recipes', 
    where: 'deleted = ?',
    whereArgs: [0]);
  }
}

class Days{

  Future<void> insert(String dayId, double costGoal, double caloriesGoal, double proteinGoal, double carbsGoal, double fatsGoal, String createdAt)async{
    final db = await DatabaseHelper.database;
    await db.insert(
      'days',
      {
        'day_id': dayId,
        'cost_goal': costGoal,
        'calories_goal': caloriesGoal,
        'protein_goal': proteinGoal,
        'carbs_goal': carbsGoal,
        'fats_goal': fatsGoal,
        'costs': 0,
        'calories_consumed': 0,
        'protein_consumed': 0,
        'carbs_consumed': 0,
        'fats_consumed': 0,
        'consumed': '',
        'created_at': createdAt,
      }
    );
  }
  DateTime normalize(DateTime d) {
  return DateTime(d.year, d.month, d.day);
  }

 int Daydiff(DateTime a, DateTime b) {
  a = normalize(a);
  b = normalize(b);
  return a.difference(b).inDays;
 }

 String dayIdToDate(String dayId) {

  final year = dayId.substring(0, 4);
  final month = dayId.substring(4, 6);
  final day = dayId.substring(6, 8);
  return '$day/$month/$year';
}
 
  Future<void> add_days() async {
   Map<String, dynamic>? goals = await Profile().getCurrentGoals();
   if (goals == null) return;
   if (await isTableEmpty()){
     String today = normalize(DateTime.now()).toString().split(' ').first.replaceAll('-', '');
     await insert(today, goals['cost'], goals['calories'], goals['protein'], goals['carbs'], goals['fats'], DateTime.now().toIso8601String());
   } else {
      Map<String, dynamic>? lastDay = await getLastDay();
      DateTime lastDate = DateTime.parse(lastDay!['created_at']);
      int diff = Daydiff(DateTime.now(), lastDate);
      for (int i = 1; i <= diff; i++){
        DateTime newDate = lastDate.add(Duration(days: i));
        String dayId = normalize(newDate).toString().split(' ').first.replaceAll('-', '');
        insert(dayId, goals['cost'], goals['calories'], goals['protein'], goals['carbs'], goals['fats'], newDate.toIso8601String());
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

  Future<List<Map<String, Object?>>> getAll() async{
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

  Future<Map<String, dynamic>> getById(String id) async{
    final db = await DatabaseHelper.database;
    final result = await db.query(
    'days',
    where: 'day_id = ?',
    whereArgs: [id],
    limit: 1,
  );
  Map<String, dynamic> resultMap = Map.from(result.first);
  resultMap['consumed'] = resultMap['consumed'] == '' ? [] : jsonDecode(resultMap['consumed'] as String);
  return resultMap;
  }

  Future<void> addConsumed(String day_id, Map food, double weight) async{
    final db = await DatabaseHelper.database;
    Map Day = await getById(day_id);
    List consumed = Day['consumed'] == '' ? [] : Day['consumed'];
    consumed.add([food['type'], food['id'], weight]);

    double baseWeight = food['type'] == 'ingredient'
    ? 1000
    : food['weight'];
    double factor = weight / baseWeight;

    double calories_consumed_raw = Day['calories_consumed'] + food['calories'] * factor;
    double protein_consumed_raw = Day['protein_consumed'] + food['protein'] * factor;
    double carbs_consumed_raw = Day['carbs_consumed'] + food['carbs'] * factor;
    double fats_consumed_raw = Day['fats_consumed'] + food['fats'] * factor;
    double cost_raw = Day['costs'] + food['price'] * factor;
    double calories_consumed = double.parse(calories_consumed_raw.toStringAsFixed(2));
    double protein_consumed = double.parse(protein_consumed_raw.toStringAsFixed(2));
    double carbs_consumed = double.parse(carbs_consumed_raw.toStringAsFixed(2));
    double fats_consumed = double.parse(fats_consumed_raw.toStringAsFixed(2));
    double cost = double.parse(cost_raw.toStringAsFixed(2));
    await db.update('days',
    {
      'costs': cost,
      'calories_consumed': calories_consumed,
      'protein_consumed': protein_consumed,
      'carbs_consumed': carbs_consumed,
      'fats_consumed': fats_consumed,
      'consumed': jsonEncode(consumed),
    },
    where: 'day_id = ?',
    whereArgs: [day_id],
    );
  }

  Future<void> removeConsumed(String day_id, int index) async {
  final db = await DatabaseHelper.database;
  Map Day = await getById(day_id);

  List consumed = Day['consumed'] == '' ? [] : Day['consumed'];

  var item = consumed[index];
  Map food = item[0] == 'recipe' ? await Recipes().getByid(item[1]) : await Ingredients().getByid(item[1]);
  double weight = item[2];

  double baseWeight = item[0] == 'ingredient'
      ? 1000
      : food['weight'];

  double factor = weight / baseWeight;

  double calories_raw =
      Day['calories_consumed'] - food['calories'] * factor;

  double protein_raw =
      Day['protein_consumed'] - food['protein'] * factor;

  double carbs_raw =
      Day['carbs_consumed'] - food['carbs'] * factor;

  double fats_raw =
      Day['fats_consumed'] - food['fats'] * factor;

  double cost_raw =
      Day['costs'] - food['price'] * factor;

  double calories = double.parse(calories_raw.toStringAsFixed(2));
  double protein = double.parse(protein_raw.toStringAsFixed(2));
  double carbs = double.parse(carbs_raw.toStringAsFixed(2));
  double fats = double.parse(fats_raw.toStringAsFixed(2));
  double cost = double.parse(cost_raw.toStringAsFixed(2));

  consumed.removeAt(index);

  await db.update(
    'days',
    {
      'costs': cost,
      'calories_consumed': calories,
      'protein_consumed': protein,
      'carbs_consumed': carbs,
      'fats_consumed': fats,
      'consumed': jsonEncode(consumed),
    },
    where: 'day_id = ?',
    whereArgs: [day_id],
  );
}

} 

class Profile{
  Future<void> insert(String name, double height, String birthDate)async{
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

  Future<Map<String, dynamic>?> getProfile() async{
    final db = await DatabaseHelper.database;
    final result = await db.query('profile', where: 'id = 1', limit: 1);
    if (result.isEmpty) return null;
    return Map.from(result.first);
  }

  Future<void> update(String name, double height, String birthDate) async{
    final db = await DatabaseHelper.database;
    if ((await db.query('profile')).isEmpty){
      await insert(name, height, birthDate);
      return;
    }
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

  Future<void> goalInsert(double weight, double cost, double calories, double protein, double carbs, double fats) async {
    final db = await DatabaseHelper.database;
    final now = DateTime.now();
    await db.insert(
      'goals',
      {
        'weight': weight,
        'cost': cost,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'created_at': now.toIso8601String(),
      }
    );
  }
  Future<Map<String, dynamic>?>getCurrentGoals() async {
    final db = await DatabaseHelper.database;
    final result = await db.query(
      'goals',
      orderBy: 'created_at DESC',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Map.from(result.first);
  }

  Future<List<Map<String, Object?>>> getAllGoals() async {
    final db = await DatabaseHelper.database;
    return await db.query('goals', orderBy: 'created_at DESC');
  }
}