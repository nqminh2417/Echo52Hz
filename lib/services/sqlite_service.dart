import 'package:sqflite/sqflite.dart';

import '../helpers/sqlite_helper.dart';
import '../models/role.dart';

class SQLiteService {
  static Future<List<String>> getAllTableNames() async {
    final db = await SQLiteHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
    return List.generate(maps.length, (index) {
      return maps[index]['name'] as String;
    });
  }

  static Future<List<Role>> getAllRoles() async {
    final db = await SQLiteHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('roles');

    return List.generate(maps.length, (index) {
      return Role.fromMap(maps[index]);
    });
  }

  static Future<Role?> getRoleByCdOrId(String identifier) async {
    final db = await SQLiteHelper.database;

    // Check if the identifier is a valid integer (likely an id)
    int? id = int.tryParse(identifier);

    if (id != null) {
      // Query by id
      final maps = await db.query('roles', where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        return Role.fromMap(maps.first);
      }
    } else {
      // Query by role_cd
      final maps = await db.query('roles', where: 'role_cd = ?', whereArgs: [identifier]);
      if (maps.isNotEmpty) {
        return Role.fromMap(maps.first);
      }
    }

    return null; // Role not found
  }

  static Future<bool> insertRole(Role role) async {
    final db = await SQLiteHelper.database;

    try {
      await db.insert('roles', role.toMapSqlite());
      return true; // Insertion successful
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        // Handle duplicate role_cd error
        print('Role code already exists');
        return false; // Insertion failed due to duplicate
      } else {
        // Handle other database exceptions
        rethrow;
      }
    }
  }

// check this
  static Future<bool> updateRole(Role role) async {
    final db = await SQLiteHelper.database;

    try {
      final count = await db.update(
        'roles',
        role.toMapSqlite(),
        where: '_id = ?',
        whereArgs: [role.id],
      );
      return count > 0;
    } catch (e) {
      // Handle specific errors, like constraint violations or others
      print('Error updating role: $e');
      return false; // Indicate update failure
    }
  }
}
