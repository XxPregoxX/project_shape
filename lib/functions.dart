import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Ingredients{
    static Database? _database;

    Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async{
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
      fats REAL, 
      deleted boolean DEFAULT 0
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

  Future<void> update(int id, String name, double price, double calories, double proteins, double carbs, double fats) async{
    final db = await database;
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
    final db = await database;
    await db.update('ingredients',
    {
      'deleted': 1,
    },
    where: 'id = ?',
    whereArgs: [id],
    );
  }

  Future<void> restore(int id) async{
    final db = await database;
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
    final db = await database;
    return await db.query('ingredients');
  }

}

class Meals{
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
      return db.execute('''CREATE TABLE meals(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT, 
      ingredients TEXT, 
      description TEXT,
      deleted boolean DEFAULT 0
      )''');
    },
  );
  }

  insert(String name, String ingredients, String description)async{
    final db = await database;
    await db.insert(
      'meals',
      {
        'name': name,
        'ingredients': ingredients,
        'description': description,
      }
    );
  }
}