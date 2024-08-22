import 'package:flutter/material.dart';
import 'features/Test/test_screen.dart';
import 'features/admin/roles/role_list_screen.dart';
import 'features/authentication/login_screen.dart';
import 'features/home/home_screen.dart';

final appRoutes = <String, WidgetBuilder>{
  '/': (context) => const LoginScreen(),
  '/home': (context) => const HomeScreen(),
  '/roles': (context) => const RoleListScreen(),
  '/test': (context) => const TestScreen(),
  // Add more routes as needed
};
