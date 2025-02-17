import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/planet.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Chama o inicio do banco de dados
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase('planets.db');
    return _database!;
  }

  // Inicia o banco procurando dados na memória
  Future<Database> initDatabase(String filePath) async {
    if (filePath == ':memory:') {
      return await openDatabase(filePath, version: 1, onCreate: _createDB);
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> closeDatabase() async {
    final db = await instance.database;
    db.close();
  }

  // Cria a tabela do banco
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE planets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        distance REAL NOT NULL,
        size INTEGER NOT NULL,
        nickname TEXT
      )
    ''');
  }

  // Adiciona um planeta no banco
  Future<int> insertPlanet(Planet planet) async {
    final db = await instance.database;
    return await db.insert('planets', planet.toMap());
  }

  // Lista os planetas do banco
  Future<List<Planet>> getPlanets() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('planets');

    // Log para debug
    debugPrint('Planetas no banco: $maps');
    return maps.map((map) => Planet.fromMap(map)).toList();
  }

  // Lista os planetas do banco
  Future<List<Planet>> getAllPlanets() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('planets');
    return List.generate(maps.length, (i) => Planet.fromMap(maps[i]));
  }

  Future<int> updatePlanet(Planet planet) async {
    final db = await instance.database;
    return await db.update(
      'planets',
      planet.toMap(),
      where: 'id = ?',
      whereArgs: [planet.id],
    );
  }

  // Apaga um planeta do banco
  Future<int> deletePlanet(int id) async {
    final db = await instance.database;
    return await db.delete('planets', where: 'id = ?', whereArgs: [id]);
  }
}
