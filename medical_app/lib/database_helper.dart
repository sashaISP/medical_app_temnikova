import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'medical_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE diagnoses (
            id INTEGER PRIMARY KEY,
            name TEXT,
            symptoms TEXT,
            recommendationsAndPrecautions TEXT,
            doctor TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE symptoms (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertDiagnosis(Map<String, dynamic> diagnosis) async {
    final db = await database;
    await db!.insert('diagnoses', diagnosis);
  }

  Future<void> insertSymptom(Map<String, dynamic> symptom) async {
    final db = await database;
    await db!.insert('symptoms', symptom);
  }

  Future<List<Map<String, dynamic>>> getDiagnoses() async {
    final db = await database;
    return await db!.query('diagnoses');
  }

  Future<List<Map<String, dynamic>>> getSymptoms() async {
    final db = await database;
    return await db!.query('symptoms');
  }

  Future<void> clearDiagnoses() async {
    final db = await database;
    await db!.delete('diagnoses');
  }

  Future<void> clearSymptoms() async {
    final db = await database;
    await db!.delete('symptoms');
  }
}
