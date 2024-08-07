import 'package:echo_52hz/services/sqlite_service.dart';
import 'package:flutter/material.dart';

import '../../helpers/password_hasher.dart';
import '../../services/mongodb_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> users = [];
  List<String?> collNames = [];

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
      final fetchedUsers = await MongoDBService.getData('core_db', 'users');
      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    } finally {
      await MongoDBService.close('core_db');
    }
  }

  Future<void> _fetchData2() async {
    try {
      final fetchedCollNames = await MongoDBService.getCollectionNames('core_db');
      setState(() {
        collNames = fetchedCollNames;
      });
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    } finally {
      await MongoDBService.close('core_db');
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
      final aaa = await MongoDBService.loginUser('core_db', 'un123', 'zxc.123456');
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
      final roles = await MongoDBService.getAllRoles('core_db');
      print(roles);
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    } finally {
      await MongoDBService.close('core_db');
    }
  }

  void _testGetRole() async {
    try {
      final role = await MongoDBService.getRole('core_db', '66b2e73ab03dd04f7f000000');
      print(role);
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    } finally {
      await MongoDBService.close('core_db');
    }
  }

  void _testInsertRole() async {
    try {
      const databaseName = 'core_db';
      final roleData = {
        "role_cd": "TEST",
        "role_nm": "Role Test",
        "descr": "chỉ test thôi",
        "crt_by": "user123",
        "crt_dt": DateTime.now(),
        "upd_by": "user123",
        "upd_dt": DateTime.now(),
        "permissions": ["view_users", "create_users", "edit_users", "delete_users"],
      };

      final success = await MongoDBService.insertRole(databaseName, roleData);
      if (success) {
        print('Role inserted successfully');
      } else {
        print('Failed to insert role');
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    } finally {
      await MongoDBService.close('core_db');
    }
  }

  void _testUpdateRole() async {
    try {
      const databaseName = 'core_db';
      const roleId = '66b2e73ab03dd04f7f000000';
      final roleData = {
        "role_nm": "Role Test Update",
        "descr": "test update 2",
        "crt_by": "user123",
        "crt_dt": DateTime.now(),
        "upd_by": "user123",
        "upd_dt": DateTime.now(),
      };

      final success = await MongoDBService.updateRole(databaseName, roleId, roleData);
      if (success) {
        print('Role updated successfully');
      } else {
        print('Failed to update role');
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    } finally {
      await MongoDBService.close('core_db');
    }
  }

  void _testInitSQLiteDB() {
    SQLiteService.initDatabase();
    print("sqlite database created");
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
            ElevatedButton(onPressed: _testInitSQLiteDB, child: const Text('Init SQLite DB')),
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
