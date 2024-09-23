import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/constants.dart';
import '../utils/string_utils.dart';

class SQLiteHelper {
  static const _databaseName = sqliteDatabaseName;
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
      StringUtils.debugLog('Error opening database: $e');
      rethrow; // or handle the error appropriately
    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create tables and initial data here
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ROLES (
        _id TEXT,
        role_code TEXT PRIMARY KEY UNIQUE,
        role_name TEXT,
        description TEXT,
        created_by TEXT,
        created_at TEXT,
        updated_by TEXT,
        updated_at TEXT,
        permissions TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS MENU_SETS (
        _id TEXT PRIMARY KEY,
        role_code TEXT,
        m_items TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS MENU_ITEMS (
        _id TEXT PRIMARY KEY,
        menu_name TEXT,
        route TEXT,
        icon TEXT,
        is_parent INTEGER,
        parent_id TEXT,
        is_active INTEGER,
        order_id INTEGER,
        created_by TEXT,
        created_at TEXT,
        updated_by TEXT,
        updated_at TEXT
      )
    ''');
  }

  static Future<void> resetDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    // Delete the database file
    await deleteDatabase(path);

    // Reinitialize the database
    _database = null; // Ensure the database is closed
    await _initDatabase();
  }

  static Future<void> delDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    try {
      await deleteDatabase(path);
    } catch (e) {
      StringUtils.debugLog('Error deleting database (1): $e');
      rethrow; // or handle the error appropriately
    }
  }
}
