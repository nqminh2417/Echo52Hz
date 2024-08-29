import '../../models/role.dart';
import '../../services/mongodb_service.dart';
import '../../services/sqlite_service.dart';

class DataSyncService {
  static syncData() async {
    // Fetch roles from MongoDB
    final mongoRoles = await MongoDBService.getAllRoles();
    // print(mongoRoles);

    // Insert or update roles in SQLite
    for (Role mongoRole in mongoRoles) {
      final existingRole = await SQLiteService.getRoleByCdOrId(mongoRole.id!);
      if (existingRole == null) {
        await SQLiteService.insertRole(mongoRole);
      } else {
        await SQLiteService.updateRole(mongoRole);
      }
    }
  }
}
