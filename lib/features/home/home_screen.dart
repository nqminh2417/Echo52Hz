import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/side_menu.dart';
import '../Test/test_screen.dart';
import '../authentication/login_screen.dart';
import '../data_sync/data_sync_screen.dart';
import '../the_movie_database/tmdb_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Home Screen',
        ),
      ),
      drawer: const SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: const Text('1'),
              title: const Text('Sync Data'),
              trailing: const Icon(Icons.sync),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const DataSyncModal(),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Text('2'),
              title: const Text('Go to Role Screen'),
              trailing: const Icon(Icons.list),
              onTap: () {
                // Navigator.pushNamedAndRemoveUntil(context, '/roles', (route) => false);
                Navigator.pushNamed(context, '/roles');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Text('3'),
              title: const Text('Go to MenuItem Screen'),
              trailing: const Icon(Icons.list),
              onTap: () {
                // Navigator.pushNamedAndRemoveUntil(context, '/roles', (route) => false);
                Navigator.pushNamed(context, '/menus');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Text('4'),
              title: const Text('Device Info'),
              trailing: const Icon(Icons.perm_device_information),
              onTap: () {
                Navigator.pushNamed(context, '/device-info');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Text('5'),
              title: const Text('The Movie Database'),
              trailing: const Icon(Icons.movie),
              onTap: () {
                Navigator.pushNamed(context, '/tmdb');
              },
            ),
            const Divider(),
            const Text('Welcome to the Home Screen!'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TestScreen()),
                );
              },
              child: const Text('Go to Test Screen'),
            ),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here, e.g., navigate to another screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
