import 'package:echo_52hz/features/clock/clock_screen.dart';
import 'package:echo_52hz/helpers/sqlite_helper.dart';
import 'package:echo_52hz/models/role.dart';
import 'package:echo_52hz/services/sqlite_service.dart';
import 'package:echo_52hz/utils/string_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../helpers/password_hasher.dart';
import '../../services/mongodb_service.dart';
import '../../widgets/loading_indicators/three_bounce.dart';
import '../../widgets/qm_button.dart';
import '../../widgets/text_field/floating_label.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> users = [];
  List<String?> collNames = [];
  bool _isResetting = false;
  final TextEditingController _FloatingLabelCtrler = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _fetchData();
    // _fetchData2();
    // _fetchData3();
    // _fetchData4();
  }

  Future<void> _fetchData() async {
    try {
      final fetchedUsers = await MongoDBService.getData('users');
      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    } finally {
      await MongoDBService.close();
    }
  }

  Future<void> _fetchData2() async {
    try {
      final fetchedCollNames = await MongoDBService.getCollectionNames();
      setState(() {
        collNames = fetchedCollNames;
      });
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    } finally {
      await MongoDBService.close();
    }
  }

  Future<void> _fetchData3() async {
    try {
      // Hash the password
      final hashedPassword = await PasswordHasher.hashPassword("zxc.123456");
      StringUtils.debugLog('Hashed Password: $hashedPassword');
      // Verify the password
      final isPasswordValid = PasswordHasher.verifyPassword("zxc.123456", hashedPassword);
      StringUtils.debugLog('Password Valid: $isPasswordValid');
      // Verify a wrong password
      final isWrongPasswordValid = PasswordHasher.verifyPassword('wrongpassword', hashedPassword);
      StringUtils.debugLog('Wrong Password Valid: $isWrongPasswordValid');
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    } finally {
      // await MongoDBService.close('core_db');
    }
  }

  Future<void> _fetchData4() async {
    try {
      final aaa = await MongoDBService.loginUser('un123', 'zxc.123456');
      StringUtils.debugLog("4444");
      StringUtils.debugLog(aaa);
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    } finally {
      // await MongoDBService.close('core_db');
    }
  }

  void _testGetAllRoles() async {
    try {
      final roles = await MongoDBService.getAllRoles();
      StringUtils.debugLog(roles);
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    }
  }

  void _testGetRole() async {
    try {
      final role = await MongoDBService.getRole('66d02eab6cf648b00e000000');
      StringUtils.debugLog(role);
      // StringUtils.debugLog(role!.permissions![0]);
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    }
  }

  void _testInsertRole() async {
    try {
      Role roleData = Role(
        roleCode: "TEST-4",
        roleName: "Role Test 4",
        description: "test lần 4",
        createdBy: "user123",
        createdAt: DateTime.now(),
        updatedBy: "user123",
        updatedAt: DateTime.now(),
        // permissions: ["view_users", "create_users", "edit_users", "delete_users"]
      );

      StringUtils.debugLog(DateTime.now());
      final insertedRole = await MongoDBService.insertRole(roleData);
      if (insertedRole != null) {
        // Handle successful insertion
        StringUtils.debugLog('Role inserted successfully: ${insertedRole.toJson()}');
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog('Unexpected error: $e');
    }
  }

  void _testUpdateRole() async {
    try {
      // const roleId = '66b2e73ab03dd04f7f000000';
      // final roleData = {
      //   "role_name": "Role Test Update",
      //   "description": "test update 5",
      //   "created_by": "user123",
      //   "created_at": DateTime.now(),
      //   "updated_by": "user123",
      //   "updated_at": DateTime.now(),
      // };
//----------------------------------------------------------------
      Role roleData = Role(
          id: "66ac76aec0030fec33cd058a",
          roleCode: "BASIC",
          roleName: "Basic User",
          // description: "test update 6",
          createdBy: "Minh",
          createdAt: DateTime.now(),
          updatedBy: "Minh",
          updatedAt: DateTime.now(),
          permissions: ["view_users", "create_users", "edit_users", "delete_users"]);

      final success = await MongoDBService.updateRole(roleData);
      if (success) {
        StringUtils.debugLog('Role updated successfully');
      } else {
        StringUtils.debugLog('Failed to update role');
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    }
  }

  void _testGetAllMenuSets() async {
    try {
      final menuSets = await MongoDBService.getMenuSets();
      StringUtils.debugLog(menuSets);
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    }
  }

  void _testGetAllMenuItems() async {
    try {
      final menuItems = await MongoDBService.getMenuItems();
      StringUtils.debugLog(menuItems);
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    }
  }

  void _testSQliteGetAllTableNames() async {
    final tables = await SQLiteService.getAllTableNames();
    StringUtils.debugLog(tables);
  }

  void _testSQliteGetAllRoles() async {
    final roles = await SQLiteService.getAllRoles();
    final count = roles.length;
    StringUtils.debugLog('Count: $count');
    StringUtils.debugLog(roles);
  }

  void _testSQliteGetRoleByCdOrId() async {
    final role = await SQLiteService.getRoleByCdOrId('66d02eab6cf648b00e000000');
    StringUtils.debugLog(role);
  }

  void _testSQliteInsertRole() async {
    final isInserted = await SQLiteService.insertRole(Role(
        id: "gbggbgbgbgb",
        roleCode: "TEST",
        roleName: "Role Test Update",
        description: "test update 5",
        createdAt: DateTime.now()));
    if (isInserted) {
      // Handle successful insertion
      StringUtils.debugLog("Inserted role");
    } else {
      // Handle duplicate role_code error
      StringUtils.debugLog("Duplicate role");
    }
  }

// check this
  void _testSQLiteUpdateRole() async {
    try {
      const roleId = '66b2e73ab03dd04f7f000000';
      // final roleData = {
      //   "role_name": "Role Test Update",
      //   "description": "test update 1",
      //   "created_by": "user456",
      //   "created_at": DateTime.now(),
      //   "updated_by": "user123",
      //   "updated_at": DateTime.now(),
      // };

      Role roleToUpdate = Role(
          id: roleId,
          roleCode: "TEST",
          roleName: "Role Test Update",
          description: "test update 5",
          updatedAt: DateTime.now());

      final success = await SQLiteService.updateRole(roleToUpdate);
      if (success) {
        StringUtils.debugLog('Role updated successfully');
      } else {
        StringUtils.debugLog('Failed to update role');
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    }
  }

  void _testSQliteResetDB() async {
    setState(() {
      _isResetting = true;
    });

    try {
      await SQLiteHelper.resetDatabase();
      // Handle successful reset
      StringUtils.debugLog('Database reset successfully');
    } catch (e) {
      // Handle errors
      StringUtils.debugLog('Error resetting database: $e');
    } finally {
      setState(() {
        _isResetting = false;
      });
    }
  }

  void _testSQliteDeleteDB() async {
    setState(() {
      _isResetting = true;
    });

    try {
      await SQLiteHelper.delDatabase();
      // Handle successful reset
      StringUtils.debugLog('Database delete successfully');
    } catch (e) {
      // Handle errors
      StringUtils.debugLog('Error deleting database (2): $e');
    } finally {
      setState(() {
        _isResetting = false;
      });
    }
  }

  void _testSQLiteGetAllMenuSets() async {
    try {
      final menuSets = await SQLiteService.getMenuSets();
      StringUtils.debugLog(menuSets);
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    }
  }

  void _testSQLiteGetAllMenuItems() async {
    try {
      final menuItems = await SQLiteService.getMenuItems();
      StringUtils.debugLog(menuItems);
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    }
  }

  void _testSQLiteGetMenuItemsByRoleCode() async {
    try {
      final menuItems = await SQLiteService.getMenuItemsByRoleCode('ADMIN');
      StringUtils.debugLog(menuItems);
    } catch (e) {
      // Handle errors, e.g., show an error message
      StringUtils.debugLog(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Test Screen',
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(),

              const Divider(),
              FloatingLabelTextField(
                label: 'Floating label',
                controller: _FloatingLabelCtrler,
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClockScreen()),
                  );
                },
                child: const Text('Go to Clock Screen'),
              ),
              QMButton(
                text: 'My Button',
                onPressed: () {
                  StringUtils.debugLog("My Button");
                },
              ),
              // const Divider(),
              // Container(
              //     height: 60, decoration: const BoxDecoration(color: Colors.lightBlueAccent), child: const ThreeBounce()),
              const Divider(),
              ElevatedButton(
                  onPressed: _testSQLiteGetMenuItemsByRoleCode, child: const Text('SQLite: Get MenuItems By RoleCode')),
              ElevatedButton(onPressed: _testSQLiteGetAllMenuSets, child: const Text('SQLite: Get all menu sets')),
              ElevatedButton(onPressed: _testSQLiteGetAllMenuItems, child: const Text('SQLite: Get all menu items')),
              ElevatedButton(onPressed: _testSQliteGetAllTableNames, child: const Text('SQLite: Get All Table Names')),
              ElevatedButton(onPressed: _testSQliteGetAllRoles, child: const Text('SQLite: Get All Roles')),
              ElevatedButton(
                  onPressed: _testSQliteGetRoleByCdOrId, child: const Text('SQLite: Get Role By role_code Or _id')),
              ElevatedButton(onPressed: _testSQliteInsertRole, child: const Text('SQLite: Insert Role')),
              ElevatedButton(onPressed: _testSQLiteUpdateRole, child: const Text('SQLite: Update Role')),
              ElevatedButton(
                  onPressed: _isResetting ? null : _testSQliteDeleteDB,
                  child: Text(_isResetting ? 'Deleting...' : 'SQLite: Delete Database')),
              ElevatedButton(
                  onPressed: _isResetting ? null : _testSQliteResetDB,
                  child: Text(_isResetting ? 'Resetting...' : 'SQLite: Reset Database')),
              Visibility(
                visible: _isResetting,
                child: const CircularProgressIndicator(),
              ),
              const Divider(),
              ElevatedButton(onPressed: _testGetAllMenuSets, child: const Text('Get all menu sets')),
              ElevatedButton(onPressed: _testGetAllMenuItems, child: const Text('Get all menu items')),
              ElevatedButton(onPressed: _testGetAllRoles, child: const Text('Get All Roles')),
              ElevatedButton(onPressed: _testGetRole, child: const Text('Get Role')),
              ElevatedButton(onPressed: _testInsertRole, child: const Text('Insert Role')),
              ElevatedButton(onPressed: _testUpdateRole, child: const Text('Update Role')),
            ],
          ),
        ),
      ),
    );
  }
}
