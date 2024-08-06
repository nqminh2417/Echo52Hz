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
    _fetchData4();
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
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(user['dsp_nm']),
                subtitle: Text(user['email']),
              ),
              ListTile(
                title: Text(user['dsp_nm']),
                subtitle: Text(user['email']),
              ),
            ],
          );
        },
      ),
    );
  }
}
