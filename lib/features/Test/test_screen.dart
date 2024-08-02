import 'package:flutter/material.dart';

import '../../services/mongodb_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchData2();
  }

  Future<void> _fetchData2() async {
    try {
      final fetchedUsers = await MongoDBService.getCollectionNames('core_db');
      // setState(() {
      //   users = fetchedUsers;
      // });
    } catch (e) {
      // Handle errors, e.g., show an error message
      print(e);
    } finally {
      await MongoDBService.close('core_db');
    }
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
