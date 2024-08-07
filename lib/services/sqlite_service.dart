import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteService {
  static const _databaseName = 'echo.db';
  static const _databaseVersion = 1;

  static late Database _database;

  static Future<void> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, _databaseName);

    _database = await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Optional: for database schema changes
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create tables and initial data here
    await db.execute('''
      CREATE TABLE IF NOT EXISTS roles (
        _id TEXT PRIMARY KEY,
        role_cd TEXT,
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

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema changes
  }

  static Future<void> resetDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    await deleteDatabase(path);
    await initDatabase();
  }

  static Future<void> deleteDatabase(String path) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    await deleteDatabase(path);
  }

  // static Future<void> createTable(String tableName, String createSql) async {
  //   final db = await database;
  //   await db.execute('CREATE TABLE $tableName ($createSql)');
  // }
}
