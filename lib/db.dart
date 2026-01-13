import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'nutrition.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE ingredients(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT, 
      price REAL, 
      calories REAL, 
      protein REAL, 
      carbs REAL, 
      fats REAL, 
      deleted boolean DEFAULT 0
      )''');
        await db.execute('''CREATE TABLE meals(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT, 
      ingredients TEXT, 
      description TEXT,
      deleted boolean DEFAULT 0
      )''');
        await db.execute('''CREATE TABLE days(
      day_id TEXT PRIMARY KEY,
      cost_goal REAL,
      calories_goal REAL,
      protein_goal REAL,
      carbs_goal REAL,
      fats_goal REAL,
      consumed TEXT,
      created_at TEXT
      )''');
      },
    );
  }
}