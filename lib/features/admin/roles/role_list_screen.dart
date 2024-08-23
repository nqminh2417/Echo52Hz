import 'package:flutter/material.dart';

import '../../../models/role.dart';
import '../../../services/sqlite_service.dart';
import 'role_form_screen.dart';

class RoleListScreen extends StatefulWidget {
  const RoleListScreen({super.key});

  @override
  State<RoleListScreen> createState() => _RoleListScreenState();
}

class _RoleListScreenState extends State<RoleListScreen> {
  List<Role> _roles = [];

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  Future<void> _fetchRoles() async {
    final result = await SQLiteService.getAllRoles();

    setState(() {
      _roles = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // Navigate to add role screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RoleFormScreen(roleId: null),
                ),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          final role = _roles[index];
          return ListTile(
            title: Text(role.roleName),
            subtitle: Text(role.description!),
            onTap: () {
              // Navigate to edit role screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoleFormScreen(roleId: role.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
