import 'package:mongo_dart/mongo_dart.dart';
import '../../helpers/password_hasher.dart';
import '../models/menu_item.dart';
import '../models/menu_set.dart';
import '../models/role.dart';
import '../utils/constants.dart';
import '../utils/string_utils.dart';

class MongoDBService {
  // static const databaseName = 'core_db';
  static final Map<String, Db> _dbs = {};

  static Future<void> connect() async {
    if (_dbs.containsKey(databaseName)) {
      return; // Database already connected
    }

    const connectionString = 'mongodb+srv://admin:zxc123@clusterflutter.vnmcr2s.mongodb.net/$databaseName?retryWrites=true&w=majority&appName=ClusterFlutter';
    final db = await Db.create(connectionString);
    await db.open();
    _dbs[databaseName] = db;
  }

  static Future<void> close() async {
    if (_dbs.containsKey(databaseName)) {
      await _dbs[databaseName]!.close();
      _dbs.remove(databaseName);
    }
  }

  static Future<List<String?>> getCollectionNames() async {
    await connect();
    final db = _dbs[databaseName]!;
    final collectionNames = await db.getCollectionNames();
    return collectionNames;
  }

  static Future<Map<String, dynamic>?> loginUser(String credential, String password) async {
    await connect();
    final db = _dbs[databaseName]!;
    final usersCollection = db.collection('users');

    // Define potential search fields
    final searchFields = ['usrnm', 'email', 'phone', 'usr_id'];

    for (final field in searchFields) {
      final user = await usersCollection.findOne({field: credential});

      if (user != null) {
        // Verify password
        if (PasswordHasher.verifyPassword(password, user['pwd_hash'])) {
          StringUtils.debugLog("verify password");
          StringUtils.debugLog(user);
          return user;
        } else {
          // Incorrect password
          return null;
        }
      }
    }

    return null; // User not found
  }

  static Future<List<Role>> getAllRoles() async {
    try {
      await connect();
      final db = _dbs[databaseName]!;
      final rolesCollection = db.collection('roles');

      final rolesData = await rolesCollection.find().toList();
      return rolesData.map((roleData) => Role.fromMap(roleData)).toList();
    } catch (e) {
      StringUtils.debugLog('Error getting all roles: $e');
      rethrow;
    } finally {
      await close();
    }
  }

  static Future<Role?> getRole(String roleId) async {
    try {
      await connect();
      final db = _dbs[databaseName]!;
      final rolesCollection = db.collection('roles');

      final roleData = await rolesCollection.findOne({'_id': ObjectId.fromHexString(roleId)});
      if (roleData == null) {
        return null; // Role not found
      }
      return Role.fromMap(roleData);
    } catch (e) {
      StringUtils.debugLog('Error getting role: $e');
      return null;
    } finally {
      await close();
    }
  }

  static Future<Role?> insertRole(Role newRole) async {
    try {
      await connect();
      final db = _dbs[databaseName]!;
      final rolesCollection = db.collection('roles');

      // Check for existing role code
      final existingRole = await rolesCollection.findOne({'role_code': newRole.roleCode});
      if (existingRole != null) {
        throw Exception('Role with code "${newRole.roleCode}" already exists');
      }

      final result = await rolesCollection.insertOne(newRole.toMap());
      final insertedId = result.id as ObjectId;
      final insertedRole = await rolesCollection.findOne({'_id': insertedId});

      if (insertedRole == null) {
        throw Exception('Failed to insert role');
      }

      return Role.fromMap(insertedRole);
    } catch (e) {
      // Handle other errors
      StringUtils.debugLog('Error inserting role: $e');
      rethrow; // Rethrow to be caught in the calling code
    } finally {
      await close();
    }
  }

  static Future<bool> updateRole(Role updatedRole) async {
    try {
      await connect();
      final db = _dbs[databaseName]!;
      final rolesCollection = db.collection('roles');

      final Map<String, dynamic> updateData = {};
      updatedRole.toMap().forEach((key, value) {
        if (key != '_id' && value != null) {
          updateData[key] = value;
        }
      });

      final updateResult = await rolesCollection.updateOne({'_id': ObjectId.fromHexString(updatedRole.id.toString())}, {'\$set': updateData});
      return updateResult.isSuccess;
    } catch (e) {
      StringUtils.debugLog('Error updating role: $e');
      return false;
    } finally {
      await close();
    }
  }

  static Future<List<Map<String, dynamic>>> getData(String collectionName) async {
    await connect();
    final db = _dbs[databaseName]!;
    final coll = db.collection(collectionName);
    final results = await coll.find().toList();
    return results;
  }

  // * Menu Sets
  static Future<List<MenuSet>> getMenuSets() async {
    try {
      await connect();
      final db = _dbs[databaseName]!;
      final menuSetsCollection = db.collection('menu_sets');

      final menuSetsData = await menuSetsCollection.find().toList();
      return menuSetsData.map((menu) => MenuSet.fromMap(menu)).toList();
    } catch (e) {
      StringUtils.debugLog('Error getting MenuSets list: $e');
      return [];
    } finally {
      await close();
    }
  }

  // * Menu Items
  static Future<List<MenuItem>> getMenuItems() async {
    try {
      await connect();
      final db = _dbs[databaseName]!;
      final menuItemsCollection = db.collection('menu_items');

      final menuItemsData = await menuItemsCollection.find().toList();
      return menuItemsData.map((menu) => MenuItem.fromMap(menu)).toList();
    } catch (e) {
      StringUtils.debugLog('Error getting MenuItems list: $e');
      return [];
    } finally {
      await close();
    }
  }

  static Future<MenuItem?> insertMenuItem(MenuItem newMenuItem) async {
    try {
      await connect();
      final db = _dbs[databaseName]!;
      final menuItemsCollection = db.collection('menu_items');

      // Check for existing menu item
      final existingMenuItem = await menuItemsCollection.findOne({'menu_name': newMenuItem.menuName});
      if (existingMenuItem != null) {
        throw Exception('Role with code "${newMenuItem.menuName}" already exists');
      }

      final result = await menuItemsCollection.insertOne(newMenuItem.toMap());
      final insertedId = result.id as ObjectId;
      final insertedMenuItem = await menuItemsCollection.findOne({'_id': insertedId});

      if (insertedMenuItem == null) {
        throw Exception('Failed to insert menu item with id ${newMenuItem.menuName}');
      }

      return MenuItem.fromMap(insertedMenuItem);
    } catch (e) {
      // Handle other errors
      StringUtils.debugLog('Error inserting role: $e');
      rethrow; // Rethrow to be caught in the calling code
    } finally {
      await close();
    }
  }

  static Future<bool> updateMenuItem(MenuItem updatedMenuItem) async {
    try {
      await connect();
      final db = _dbs[databaseName]!;
      final menuItemsCollection = db.collection('menu_items');

      final Map<String, dynamic> updateData = {};
      updatedMenuItem.toMap().forEach((key, value) {
        if (key != '_id' && value != null) {
          updateData[key] = value;
        }
      });

      final updateResult = await menuItemsCollection.updateOne({'_id': ObjectId.fromHexString(updatedMenuItem.id.toString())}, {'\$set': updateData});
      return updateResult.isSuccess;
    } catch (e) {
      StringUtils.debugLog('Error updating role: $e');
      return false;
    } finally {
      await close();
    }
  }
}
