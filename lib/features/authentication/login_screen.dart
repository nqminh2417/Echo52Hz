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
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void _login() async {
    try {
      // final email = _emailController.text;
      // final password = _passwordController.text;
      const email = 'minh@gmail.com';
      const password = '123456';
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
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
        Positioned(
          top: (emailFocusNode.hasFocus || passwordFocusNode.hasFocus)
              ? MediaQuery.of(context).size.height / 3
              : MediaQuery.of(context).size.height / 2,
          left: 0,
          right: 0,
          // height: MediaQuery.of(context).size.height * 1 / 3,
          child: Card(
            color: Colors.transparent,
            // shadowColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: emailFocusNode,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: emailFocusNode.hasFocus
                              ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2.0,
                                    blurRadius: 5.0,
                                    offset: const Offset(0, 2), // Move shadow down and slightly to the right
                                  ),
                                ]
                              : null,
                          border: emailFocusNode.hasFocus
                              ? Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                )
                              : null,
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color(0xfff8fafc),
                            hintText: 'Enter your email',
                            hintStyle: const TextStyle(color: Color(0xff94a3b8)),
                            isDense: true,
                            prefixIcon: const Icon(Icons.email),
                          ),
                          focusNode: emailFocusNode,
                          textInputAction: TextInputAction.next,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedBuilder(
                    animation: passwordFocusNode,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xfff8fafc),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: passwordFocusNode.hasFocus
                              ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2.0,
                                    blurRadius: 5.0,
                                    offset: const Offset(0, 2), // Move shadow down and slightly to the right
                                  ),
                                ]
                              : null,
                          border: passwordFocusNode.hasFocus
                              ? Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                )
                              : null,
                        ),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(color: Color(0xff94a3b8)),
                            isDense: true,
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          focusNode: passwordFocusNode,
                          textInputAction: TextInputAction.done,
                        ),
                      );
                    },
                  ),
                  // const Expanded(
                  //   child: SizedBox(
                  //     height: 50,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
