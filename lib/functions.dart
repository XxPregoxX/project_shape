import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Ingredients{
    static Database? _database;

    Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async{
    final String path = join( await getDatabasesPath(), 'nutrition.db');
    return await openDatabase( 
    path,
    version: 1,
    onCreate: (db, version) async {
      return db.execute('''CREATE TABLE ingredients(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT, 
      price REAL, 
      calories REAL, 
      protein REAL, 
      carbs REAL, 
      fats REAL 
      )''');
    },
  );
  }

  insert(String name, double price, double calories, double proteins, double carbs, double fats)async{
    final db = await database;
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

  getAll() async{
    final db = await database;
    return await db.query('ingredients');
  }

}