import 'package:mongo_dart/mongo_dart.dart';
import '../../helpers/password_hasher.dart';
import '../models/role.dart';

class MongoDBService {
  static final Map<String, Db> _dbs = {};

  static Future<void> connect(String databaseName) async {
    if (_dbs.containsKey(databaseName)) {
      return; // Database already connected
    }

    final connectionString =
        'mongodb+srv://admin:zxc123@clusterflutter.vnmcr2s.mongodb.net/$databaseName?retryWrites=true&w=majority&appName=ClusterFlutter';
    final db = await Db.create(connectionString);
    await db.open();
    _dbs[databaseName] = db;
  }

  static Future<void> close(String databaseName) async {
    if (_dbs.containsKey(databaseName)) {
      await _dbs[databaseName]!.close();
      _dbs.remove(databaseName);
    }
  }

  static Future<List<String?>> getCollectionNames(String databaseName) async {
    await connect(databaseName);
    final db = _dbs[databaseName]!;
    final collectionNames = await db.getCollectionNames();
    return collectionNames;
  }

  static Future<Map<String, dynamic>?> loginUser(String databaseName, String credential, String password) async {
    await connect(databaseName);
    final db = _dbs[databaseName]!;
    final usersCollection = db.collection('users');

    // Define potential search fields
    final searchFields = ['usrnm', 'email', 'phone', 'usr_id'];

    for (final field in searchFields) {
      final user = await usersCollection.findOne({field: credential});

      if (user != null) {
        // Verify password
        if (PasswordHasher.verifyPassword(password, user['pwd_hash'])) {
          print("verify password");
          print(user);
          return user;
        } else {
          // Incorrect password
          return null;
        }
      }
    }

    return null; // User not found
  }

  static Future<List<Role>> getAllRoles(String databaseName) async {
    try {
      await connect(databaseName);
      final db = _dbs[databaseName]!;
      final rolesCollection = db.collection('roles');

      final rolesData = await rolesCollection.find().toList();
      return rolesData.map((roleData) => Role.fromMap(roleData)).toList();
    } catch (e) {
      print('Error getting all roles: $e');
      rethrow;
    } finally {
      await close(databaseName);
    }
  }

  static Future<Role?> getRole(String databaseName, String roleId) async {
    try {
      await connect(databaseName);
      final db = _dbs[databaseName]!;
      final rolesCollection = db.collection('roles');

      final roleData = await rolesCollection.findOne({'_id': ObjectId.fromHexString(roleId)});
      if (roleData == null) {
        return null; // Role not found
      }
      return Role.fromMap(roleData);
    } catch (e) {
      print('Error getting role: $e');
      return null;
    } finally {
      await close(databaseName);
    }
  }

  static Future<Role?> insertRole(String databaseName, Role newRole) async {
    try {
      await connect(databaseName);
      final db = _dbs[databaseName]!;
      final rolesCollection = db.collection('roles');

      // Check for existing role code
      final existingRole = await rolesCollection.findOne({'role_cd': newRole.roleCd});
      if (existingRole != null) {
        throw Exception('Role with code "${newRole.roleCd}" already exists');
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
      print('Error inserting role: $e');
      rethrow; // Rethrow to be caught in the calling code
    } finally {
      await close(databaseName);
    }
  }

  static Future<bool> updateRole(String databaseName, Role updatedRole) async {
    try {
      await connect(databaseName);
      final db = _dbs[databaseName]!;
      final rolesCollection = db.collection('roles');

      final Map<String, dynamic> updateData = {};
      updatedRole.toMap().forEach((key, value) {
        if (key != '_id' && value != null) {
          updateData[key] = value;
        }
      });

      final updateResult = await rolesCollection
          .updateOne({'_id': ObjectId.fromHexString(updatedRole.id.toString())}, {'\$set': updateData});
      return updateResult.isSuccess;
    } catch (e) {
      print('Error updating role: $e');
      return false;
    } finally {
      await close(databaseName);
    }
  }

  static Future<List<Map<String, dynamic>>> getData(String databaseName, String collectionName) async {
    await connect(databaseName);
    final db = _dbs[databaseName]!;
    final coll = db.collection(collectionName);
    final results = await coll.find().toList();
    return results;
  }
}
