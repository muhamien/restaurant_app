import 'package:restaurant_app/data/model/favorite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    return openDatabase(
      join(path, 'restaurant_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
             id TEXT PRIMARY KEY,
             name TEXT NOT NULL,
             description TEXT,
             pictureId TEXT,
             city TEXT,
             rating REAL,
             categories TEXT,
             menus TEXT,
             customerReview TEXT
          )''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertFavorite(Favorite favorite) async {
    final Database db = await database;
    await db.insert(_tableName, favorite.toMap());
  }

  Future<List<Favorite>> getFavorites() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);
    return results.map((res) => Favorite.fromMap(res)).toList();
  }

  Future<Favorite?> getFavoriteById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) {
      return null;
    }

    return Favorite.fromMap(results.first);
  }

  Future<void> updateFavorite(Favorite favorite) async {
    final db = await database;
    await db.update(
      _tableName,
      favorite.toMap(),
      where: 'id = ?',
      whereArgs: [favorite.id],
    );
  }

  Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}