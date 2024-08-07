import 'package:echo_52hz/features/Test/test_screen.dart';
import 'package:flutter/material.dart';
import 'features/authentication/login_screen.dart';
import 'features/home/home_screen.dart';

final appRoutes = <String, WidgetBuilder>{
  '/': (context) => const LoginScreen(),
  '/home': (context) => const HomeScreen(),
  '/test': (context) => const TestScreen(),
  // Add more routes as needed
};
