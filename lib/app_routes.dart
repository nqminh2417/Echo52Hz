import 'package:flutter/material.dart';
import 'features/Test/test_screen.dart';
import 'features/admin/menu/menu_list_screen.dart';
import 'features/admin/roles/role_list_screen.dart';
import 'features/authentication/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/info/device_info_screen.dart';
import 'features/the_movie_database/tmdb_screen.dart';

final appRoutes = <String, WidgetBuilder>{
  '/': (context) => const LoginScreen(),
  '/device-info': (context) => const DeviceInfoScreen(),
  '/home': (context) => const HomeScreen(),
  '/menus': (context) => const MenuListScreen(),
  '/roles': (context) => const RoleListScreen(),
  '/test': (context) => const TestScreen(),
  '/tmdb': (context) => const TmdbScreen(),
  // Add more routes as needed
};
