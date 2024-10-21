import '../../models/menu_item.dart';
import '../../models/menu_set.dart';
import '../../models/role.dart';
import '../../services/mongodb_service.dart';
import '../../services/sqlite_service.dart';

class DataSyncService {
  static syncData() async {
    // Fetch roles from MongoDB
    final mongoRoles = await MongoDBService.getAllRoles();
    // Insert or update roles in SQLite
    for (Role mongoRole in mongoRoles) {
      final existingRole = await SQLiteService.getRoleByCdOrId(mongoRole.id!);
      if (existingRole == null) {
        await SQLiteService.insertRole(mongoRole);
      } else {
        await SQLiteService.updateRole(mongoRole);
      }
    }
    // Fetch menu_sets from MongoDB
    final mongoMenuSets = await MongoDBService.getMenuSets();
    // Insert or update menu_sets in SQLite
    for (MenuSet mongoMenuSet in mongoMenuSets) {
      final existingMenuSets = await SQLiteService.getMenuSetById(mongoMenuSet.id);
      if (existingMenuSets == null) {
        await SQLiteService.insertMenuSet(mongoMenuSet);
      } else {
        await SQLiteService.updateMenuSet(mongoMenuSet);
      }
    }
    // Fetch menu_items from MongoDB
    final mongoMenuItems = await MongoDBService.getMenuItems();
    // Insert or update menu_items in SQLite
    for (MenuItem mongoMenuItem in mongoMenuItems) {
      final existingMenuItem = await SQLiteService.getMenuMenuItemById(mongoMenuItem.id!);
      if (existingMenuItem == null) {
        await SQLiteService.insertMenuItem(mongoMenuItem);
      } else {
        await SQLiteService.updateMenuItem(mongoMenuItem);
      }
    }
  }
}
