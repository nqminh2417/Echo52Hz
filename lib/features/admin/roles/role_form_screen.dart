import 'package:flutter/material.dart';

import '../../../models/role.dart';
import '../../../services/mongodb_service.dart';
import '../../../services/sqlite_service.dart';

class RoleFormScreen extends StatefulWidget {
  final String? roleId;

  const RoleFormScreen({this.roleId, super.key});

  @override
  State<RoleFormScreen> createState() => _RoleFormScreenState();
}

class _RoleFormScreenState extends State<RoleFormScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _createByController = TextEditingController();

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
      _codeController.text = role!.roleCd;
      _nameController.text = role.roleName;
      _descriptionController.text = role.description!;
      _createByController.text = role.createdBy!;
    });
  }

// check this
  Future<void> _saveRole() async {
    if (_role == null) {
      // Add a new role
      final updatedRole = Role(
        roleCd: _codeController.text,
        roleName: _nameController.text,
        description: _descriptionController.text,
        createdBy: _createByController.text,
      );

      // await RoleService().addRole(role);
    } else {
      // Update the existing role
      final updatedRole = Role(
        id: _role?.id,
        roleCd: (_codeController.text != _role!.roleCd) ? _codeController.text : _role!.roleCd,
        roleName: _nameController.text != _role!.roleName ? _nameController.text : _role!.roleName,
        description: _descriptionController.text != _role?.description ? _descriptionController.text : null,
        createdBy: _createByController.text != _role!.createdBy ? _createByController.text : null,
        updatedAt: DateTime.now(),
      );
      await MongoDBService.updateRole("core_db", updatedRole);
      await SQLiteService.updateRole(updatedRole);
    }

    // Navigate back or show a message
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
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Role code'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _createByController,
              decoration: const InputDecoration(labelText: 'Create by'),
            ),
            ElevatedButton(
              onPressed: _saveRole,
              child: Text(_role != null ? 'Save Changes' : 'Add Role'),
            ),
          ],
        ),
      ),
    );
  }
}
