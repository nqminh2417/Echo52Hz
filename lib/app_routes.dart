import 'package:flutter/material.dart';
import 'features/Test/test_screen.dart';
import 'features/admin/roles/role_form_screen.dart';
import 'features/admin/roles/role_list_screen.dart';
import 'features/authentication/login_screen.dart';
import 'features/home/home_screen.dart';

final appRoutes = <String, WidgetBuilder>{
  '/': (context) => const LoginScreen(),
  '/home': (context) => const HomeScreen(),
  '/roles': (context) => const RoleListScreen(),
  '/roles/add': (context) => const RoleFormScreen(),
  '/roles/edit/:roleId': (context) => RoleFormScreen(roleId: ModalRoute.of(context)?.settings.arguments as String?),
  '/test': (context) => const TestScreen(),
  // Add more routes as needed
};
