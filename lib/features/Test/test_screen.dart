import 'package:echo_52hz/features/clock/clock_screen.dart';
import 'package:echo_52hz/helpers/sqlite_helper.dart';
import 'package:echo_52hz/models/role.dart';
import 'package:echo_52hz/services/sqlite_service.dart';
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
      print(e);
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
      print(e);
    } finally {
      await MongoDBService.close();
    }
  }

  Future<void> _fetchData3() async {
    try {
      // Hash the password
      final hashedPassword = await PasswordHasher.hashPassword("zxc.123456");
      print('Hashed Password: $hashedPassword');
      // Verify the password
      final isPasswordValid = PasswordHasher.verifyPassword("zxc.123456", hashedPassword);
      print('Password Valid: $isPasswordValid');
      // Verify a wrong password
      final isWrongPasswordValid = PasswordHasher.verifyPassword('wrongpassword', hashedPassword);
      print('Wrong Password Valid: $isWrongPasswordValid');
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    } finally {
      // await MongoDBService.close('core_db');
    }
  }

  Future<void> _fetchData4() async {
    try {
      final aaa = await MongoDBService.loginUser('un123', 'zxc.123456');
      print("4444");
      print(aaa);
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    } finally {
      // await MongoDBService.close('core_db');
    }
  }

  void _testGetAllRoles() async {
    try {
      final roles = await MongoDBService.getAllRoles();
      print(roles);
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    }
  }

  void _testGetRole() async {
    try {
      final role = await MongoDBService.getRole('66d02eab6cf648b00e000000');
      print(role);
      // print(role!.permissions![0]);
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    }
  }

  void _testInsertRole() async {
    try {
      Role roleData = Role(
        roleCd: "TEST-4",
        roleName: "Role Test 4",
        description: "test lần 4",
        createdBy: "user123",
        createdAt: DateTime.now(),
        updatedBy: "user123",
        updatedAt: DateTime.now(),
        // permissions: ["view_users", "create_users", "edit_users", "delete_users"]
      );

      print(DateTime.now());
      final insertedRole = await MongoDBService.insertRole(roleData);
      if (insertedRole != null) {
        // Handle successful insertion
        print('Role inserted successfully: ${insertedRole.toJson()}');
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      print('Unexpected error: $e');
    }
  }

  void _testUpdateRole() async {
    try {
      // const roleId = '66b2e73ab03dd04f7f000000';
      // final roleData = {
      //   "role_nm": "Role Test Update",
      //   "descr": "test update 5",
      //   "crt_by": "user123",
      //   "crt_dt": DateTime.now(),
      //   "upd_by": "user123",
      //   "upd_dt": DateTime.now(),
      // };
//----------------------------------------------------------------
      Role roleData = Role(
          id: "66ac76aec0030fec33cd058a",
          roleCd: "BASIC",
          roleName: "Basic User",
          // description: "test update 6",
          createdBy: "Minh",
          createdAt: DateTime.now(),
          updatedBy: "Minh",
          updatedAt: DateTime.now(),
          permissions: ["view_users", "create_users", "edit_users", "delete_users"]);

      final success = await MongoDBService.updateRole(roleData);
      if (success) {
        print('Role updated successfully');
      } else {
        print('Failed to update role');
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    }
  }

  void _testSyncData() async {
    // from MongoDB to SQLite
  }

  void _testSQliteGetAllTableNames() async {
    final tables = await SQLiteService.getAllTableNames();
    print(tables);
  }

  void _testSQliteGetAllRoles() async {
    final roles = await SQLiteService.getAllRoles();
    final count = roles.length;
    print('Count: $count');
    print(roles);
  }

  void _testSQliteGetRoleByCdOrId() async {
    final role = await SQLiteService.getRoleByCdOrId('66d02eab6cf648b00e000000');
    print(role);
  }

  void _testSQliteInsertRole() async {
    final isInserted = await SQLiteService.insertRole(Role(
        id: "gbggbgbgbgb",
        roleCd: "TEST",
        roleName: "Role Test Update",
        description: "test update 5",
        createdAt: DateTime.now()));
    if (isInserted) {
      // Handle successful insertion
      print("Inserted role");
    } else {
      // Handle duplicate role_cd error
      print("Duplicate role");
    }
  }

// check this
  void _testSQLiteUpdateRole() async {
    try {
      const roleId = '66b2e73ab03dd04f7f000000';
      // final roleData = {
      //   "role_nm": "Role Test Update",
      //   "descr": "test update 1",
      //   "crt_by": "user456",
      //   "crt_dt": DateTime.now(),
      //   "upd_by": "user123",
      //   "upd_dt": DateTime.now(),
      // };

      Role roleToUpdate = Role(
          id: roleId,
          roleCd: "TEST",
          roleName: "Role Test Update",
          description: "test update 5",
          updatedAt: DateTime.now());

      final success = await SQLiteService.updateRole(roleToUpdate);
      if (success) {
        print('Role updated successfully');
      } else {
        print('Failed to update role');
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    }
  }

  void _testSQliteResetDB() async {
    setState(() {
      _isResetting = true;
    });

    try {
      await SQLiteHelper.resetDatabase();
      // Handle successful reset
      print('Database reset successfully');
    } catch (e) {
      // Handle errors
      print('Error resetting database: $e');
    } finally {
      setState(() {
        _isResetting = false;
      });
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                print("My Button");
              },
            ),
            // const Divider(),
            // Container(
            //     height: 60, decoration: const BoxDecoration(color: Colors.lightBlueAccent), child: const ThreeBounce()),
            const Divider(),
            ElevatedButton(onPressed: _testSyncData, child: const Text('Sync data from MongoDB to SQLite')),
            ElevatedButton(onPressed: _testSQliteGetAllTableNames, child: const Text('SQLite: Get All Table Names')),
            ElevatedButton(onPressed: _testSQliteGetAllRoles, child: const Text('SQLite: Get All Roles')),
            ElevatedButton(
                onPressed: _testSQliteGetRoleByCdOrId, child: const Text('SQLite: Get Role By role_cd Or _id')),
            ElevatedButton(onPressed: _testSQliteInsertRole, child: const Text('SQLite: Insert Role')),
            ElevatedButton(onPressed: _testSQLiteUpdateRole, child: const Text('SQLite: Update Role')),
            ElevatedButton(
                onPressed: _isResetting ? null : _testSQliteResetDB,
                child: Text(_isResetting ? 'Resetting...' : 'SQLite: Reset Database')),
            Visibility(
              visible: _isResetting,
              child: const CircularProgressIndicator(),
            ),
            const Divider(),
            ElevatedButton(onPressed: _testGetAllRoles, child: const Text('Get All Roles')),
            ElevatedButton(onPressed: _testGetRole, child: const Text('Get Role')),
            ElevatedButton(onPressed: _testInsertRole, child: const Text('Insert Role')),
            ElevatedButton(onPressed: _testUpdateRole, child: const Text('Update Role')),
          ],
        ),
      ),
    );
  }
}
