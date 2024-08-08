import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHelper {
  static const _databaseName = 'echo.db';
  static const _databaseVersion = 1;

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    try {
      // Check if the database exists
      final exists = await databaseExists(path);
      if (exists) {
        return await openDatabase(path);
      } else {
        await Directory(dirname(path)).create(recursive: true);
        return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
      }
    } catch (e) {
      print('Error opening database: $e');
      rethrow; // or handle the error appropriately
    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create tables and initial data here
    await db.execute('''
      CREATE TABLE IF NOT EXISTS roles (
        _id TEXT,
        role_cd TEXT PRIMARY KEY UNIQUE,
        role_nm TEXT,
        descr TEXT,
        crt_by TEXT,
        crt_dt TEXT,
        upd_by TEXT,
        upd_dt TEXT,
        permissions TEXT
      )
    ''');
  }

  static Future<void> resetDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    // Delete the database file
    await deleteDatabase(path);

    // Reinitialize the database
    await _initDatabase();
  }

  static Future<void> delDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    try {
      await deleteDatabase(path);
    } catch (e) {
      print('Error deleting database: $e');
      rethrow; // or handle the error appropriately
    }
  }
}
