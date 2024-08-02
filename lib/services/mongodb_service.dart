import 'package:mongo_dart/mongo_dart.dart';

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

  static Future<List<Map<String, dynamic>>> getData(String databaseName, String collectionName) async {
    await connect(databaseName);
    final db = _dbs[databaseName]!;
    final coll = db.collection(collectionName);
    final results = await coll.find().toList();
    return results;
  }

  static Future<void> close(String databaseName) async {
    if (_dbs.containsKey(databaseName)) {
      await _dbs[databaseName]!.close();
      _dbs.remove(databaseName);
    }
  }
}
