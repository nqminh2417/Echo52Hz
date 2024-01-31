import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    try {
      // final email = _emailController.text;
      // final password = _passwordController.text;
      const email = 'minh@gmail.com';
      const password = '123456';
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/images/login_background.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Enter your email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'Enter your password'),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Sign in'),
            )
          ],
        ),
      ]),
    );
  }
}
