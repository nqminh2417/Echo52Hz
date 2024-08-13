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

  static Future<List<Map<String, dynamic>>> getAllRoles(String databaseName) async {
    await connect(databaseName);
    final db = _dbs[databaseName]!;
    final rolesCollection = db.collection('roles');

    final roles = await rolesCollection.find().toList();
    return roles;
  }

  static Future<Map<String, dynamic>?> getRole(String databaseName, String roleId) async {
    await connect(databaseName);
    final db = _dbs[databaseName]!;
    final rolesCollection = db.collection('roles');

    final role = await rolesCollection.findOne({'_id': ObjectId.fromHexString(roleId)});
    return role;
  }

// check this
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

// check this
  static Future<bool> updateRole(String databaseName, String roleId, Map<String, dynamic> updatedData) async {
    await connect(databaseName);
    final db = _dbs[databaseName]!;
    final rolesCollection = db.collection('roles');

    final result = await rolesCollection.updateOne({'_id': ObjectId.fromHexString(roleId)}, {'\$set': updatedData});
    return result.isSuccess;
  }

  static Future<List<Map<String, dynamic>>> getData(String databaseName, String collectionName) async {
    await connect(databaseName);
    final db = _dbs[databaseName]!;
    final coll = db.collection(collectionName);
    final results = await coll.find().toList();
    return results;
  }
}
