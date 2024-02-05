import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authentication/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _backButtonWasPressed = false;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  Future<bool> _onPopInvoked(bool result) async {
    if (!_backButtonWasPressed) {
      _backButtonWasPressed = true;
      Fluttertoast.showToast(msg: "Press again to exit app");
      Future.delayed(const Duration(seconds: 2), () => _backButtonWasPressed = false);
      return false; // Prevent route popping immediately
    }
    return true; // Allow route popping on second press
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: _onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Home Screen',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to the Home Screen!'),
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
      ),
    );
  }
}
