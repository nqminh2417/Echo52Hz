import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Test/test_screen.dart';
import '../authentication/login_screen.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ListTile(
              leading: Text('1'),
              title: Text('Go to eIS'),
              trailing: Icon(Icons.access_time),
            ),
            ListTile(
              leading: const Text('2'),
              title: const Text('Go to Role Screen'),
              trailing: const Icon(Icons.list),
              onTap: () {
                // Navigator.pushNamedAndRemoveUntil(context, '/roles', (route) => false);
                Navigator.pushNamed(context, '/roles');
              },
            ),
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
