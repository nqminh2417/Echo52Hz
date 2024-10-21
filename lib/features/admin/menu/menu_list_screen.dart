import 'package:flutter/material.dart';

import '../../../models/menu_item.dart';
import '../../../services/sqlite_service.dart';
import 'menu_form_screen.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  List<MenuItem> _menuItems = [];

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    final result = await SQLiteService.getMenuItems();

    setState(() {
      _menuItems = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // Navigate to add role screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuFormScreen(menuId: null),
                ),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final menuItem = _menuItems[index];
          return ListTile(
            title: Text(menuItem.menuName),
            subtitle: Text(menuItem.route!),
            onTap: () {
              // Navigate to edit role screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuFormScreen(menuId: menuItem.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
