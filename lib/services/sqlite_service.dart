import 'package:sqflite/sqflite.dart';

import '../helpers/sqlite_helper.dart';
import '../models/menu_item.dart';
import '../models/menu_set.dart';
import '../models/role.dart';
import '../utils/string_utils.dart';

class SQLiteService {
  static Future<List<String>> getAllTableNames() async {
    final db = await SQLiteHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
    return List.generate(maps.length, (index) {
      return maps[index]['name'] as String;
    });
  }

  //* ROLES
  static Future<List<Role>> getAllRoles() async {
    final db = await SQLiteHelper.database;

    if (db.isOpen) {
      final List<Map<String, dynamic>> maps = await db.query('ROLES');

      return List.generate(maps.length, (index) {
        return Role.fromMap(maps[index]);
      });
    } else {
      // Handle database closed error
      StringUtils.debugLog('Database is closed');
      return []; // Or throw an exception
    }
  }

  static Future<Role?> getRoleByCdOrId(String identifier) async {
    final db = await SQLiteHelper.database;
    // Query based on either id or role_code
    final maps = await db.query(
      'ROLES',
      where: '_id = ? OR role_code = ?',
      whereArgs: [identifier, identifier],
    );

    if (maps.isNotEmpty) {
      return Role.fromMap(maps.first);
    } else {
      return null; // Role not found
    }
  }

  static Future<bool> insertRole(Role role) async {
    final db = await SQLiteHelper.database;

    try {
      await db.insert('ROLES', role.toMapSqlite());
      return true; // Insertion successful
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        // Handle duplicate role_code error
        StringUtils.debugLog('Role code already exists');
        return false; // Insertion failed due to duplicate
      } else {
        // Handle other database exceptions
        rethrow;
      }
    }
  }

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
        'ROLES',
        updateData,
        where: '_id = ?',
        whereArgs: [updatedRole.id],
      );
      return count > 0;
    } catch (e) {
      // Handle specific errors, like constraint violations or others
      StringUtils.debugLog('Error updating role: $e');
      return false; // Indicate update failure
    }
  }

  //* MENU_SETS
  static Future<List<MenuSet>> getMenuSets() async {
    final db = await SQLiteHelper.database;

    if (db.isOpen) {
      final List<Map<String, dynamic>> maps = await db.query('MENU_SETS');

      return List.generate(maps.length, (index) {
        return MenuSet.fromMap(maps[index]);
      });
    } else {
      // Handle database closed error
      StringUtils.debugLog('Database is closed');
      return []; // Or throw an exception
    }
  }

  static Future<MenuSet?> getMenuSetById(String id) async {
    final db = await SQLiteHelper.database;

    final maps = await db.query('MENU_SETS', where: '_id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return MenuSet.fromMap(maps.first);
    } else {
      return null;
    }
  }

  static Future<bool> insertMenuSet(MenuSet menuSet) async {
    final db = await SQLiteHelper.database;

    try {
      await db.insert('MENU_SETS', menuSet.toMapSqlite());
      return true; // Insertion successful
    } catch (e) {
      StringUtils.debugLog('Error inserting menu sets:');
      return false;
    }
  }

  static Future<bool> updateMenuSet(MenuSet updatedMenuSet) async {
    final db = await SQLiteHelper.database;

    final Map<String, dynamic> updateData = {};
    updatedMenuSet.toMapSqlite().forEach((key, value) {
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
        'MENU_SETS',
        updateData,
        where: '_id = ?',
        whereArgs: [updatedMenuSet.id],
      );
      return count > 0;
    } catch (e) {
      // Handle specific errors, like constraint violations or others
      StringUtils.debugLog('Error updating MENU_SETS: $e');
      return false; // Indicate update failure
    }
  }

  //* MENU_ITEMS
  static Future<List<MenuItem>> getMenuItems() async {
    final db = await SQLiteHelper.database;

    if (db.isOpen) {
      final List<Map<String, dynamic>> maps = await db.query('MENU_ITEMS');

      return List.generate(maps.length, (index) {
        return MenuItem.fromMap(maps[index]);
      });
    } else {
      // Handle database closed error
      StringUtils.debugLog('Database is closed');
      return []; // Or throw an exception
    }
  }

  static Future<MenuItem?> getMenuMenuItemById(String id) async {
    final db = await SQLiteHelper.database;

    final maps = await db.query('MENU_ITEMS', where: '_id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return MenuItem.fromMap(maps.first);
    } else {
      return null;
    }
  }

  static Future<bool> insertMenuItem(MenuItem menuItem) async {
    final db = await SQLiteHelper.database;

    try {
      await db.insert('MENU_ITEMS', menuItem.toMapSqlite());
      return true; // Insertion successful
    } catch (e) {
      StringUtils.debugLog('Error inserting menu sets: $e');
      return false;
    }
  }

  static Future<bool> updateMenuItem(MenuItem updatedMenuItem) async {
    final db = await SQLiteHelper.database;

    final Map<String, dynamic> updateData = {};
    updatedMenuItem.toMapSqlite().forEach((key, value) {
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
        'MENU_ITEMS',
        updateData,
        where: '_id = ?',
        whereArgs: [updatedMenuItem.id],
      );
      return count > 0;
    } catch (e) {
      // Handle specific errors, like constraint violations or others
      StringUtils.debugLog('Error updating MENU_ITEMS: $e');
      return false; // Indicate update failure
    }
  }
}
