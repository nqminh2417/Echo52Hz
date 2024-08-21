import 'package:flutter/material.dart';

import '../../../models/role.dart';
import '../../../services/sqlite_service.dart';

class RoleFormScreen extends StatefulWidget {
  final String? roleId;

  const RoleFormScreen({this.roleId, super.key});

  @override
  State<RoleFormScreen> createState() => _RoleFormScreenState();
}

class _RoleFormScreenState extends State<RoleFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Role? _role;

  @override
  void initState() {
    super.initState();
    if (widget.roleId != null) {
      _loadRole(widget.roleId!);
    }
  }

  Future<void> _loadRole(String roleId) async {
    // Fetch the role from your data source
    final role = await SQLiteService.getRoleByCdOrId(roleId);
    setState(() {
      _role = role;
      _nameController.text = role!.roleName;
      _descriptionController.text = role.description!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_role != null ? 'Edit Role' : 'Add Role')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: null,
              child: Text(_role != null ? 'Save Changes' : 'Add Role'),
            ),
          ],
        ),
      ),
    );
  }
}
