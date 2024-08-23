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

    if (db.isOpen) {
      print('Database status: ${db.isOpen}');
      final List<Map<String, dynamic>> maps = await db.query('roles');
      return List.generate(maps.length, (index) {
        return Role.fromMap(maps[index]);
      });
    } else {
      // Handle database closed error
      print('Database is closed');
      return []; // Or throw an exception
    }
  }

  static Future<Role?> getRoleByCdOrId(String identifier) async {
    final db = await SQLiteHelper.database;

    // Query based on either id or role_cd
    final maps = await db.query(
      'roles',
      where: '_id = ? OR role_cd = ?',
      whereArgs: [identifier, identifier],
    );

    if (maps.isNotEmpty) {
      return Role.fromMap(maps.first);
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
  static Future<bool> updateRole(Role updatedRole) async {
    final db = await SQLiteHelper.database;

    final Map<String, dynamic> updateData = {};
    updatedRole.toMapSqlite().forEach((key, value) {
      if (key != '_id' && value != null) {
        updateData[key] = value;
      }
    });

    if (updateData.isEmpty) {
      // No fields have changed
      return false;
    }

    try {
      final count = await db.update(
        'roles',
        updateData,
        where: '_id = ?',
        whereArgs: [updatedRole.id],
      );
      return count > 0;
    } catch (e) {
      // Handle specific errors, like constraint violations or others
      print('Error updating role: $e');
      return false; // Indicate update failure
    }
  }
}
