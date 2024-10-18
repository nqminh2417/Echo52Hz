import 'package:flutter/material.dart';

import '../../../models/menu_item.dart';
import '../../../services/mongodb_service.dart';
import '../../../services/sqlite_service.dart';

class MenuFormScreen extends StatefulWidget {
  final String? menuId;

  const MenuFormScreen({super.key, this.menuId});

  @override
  State<MenuFormScreen> createState() => _MenuFormScreenState();
}

class _MenuFormScreenState extends State<MenuFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();
  final TextEditingController _parentIdController = TextEditingController();
  final TextEditingController _createByController = TextEditingController();
  final TextEditingController _updateByController = TextEditingController();

  MenuItem? _menuItem;

  @override
  void initState() {
    super.initState();
    if (widget.menuId != null) {
      _loadMenuItem(widget.menuId!);
    }
  }

  Future<void> _loadMenuItem(String menuId) async {
    // Fetch the role from your data source
    final menuItem = await SQLiteService.getMenuMenuItemById(menuId);
    setState(() {
      _menuItem = menuItem;
      _nameController.text = menuItem!.menuName;
      _iconController.text = menuItem.icon!;
      _parentIdController.text = menuItem.parentId!;
      _createByController.text = menuItem.createdBy!;
      _updateByController.text = menuItem.updatedBy!;
    });
  }

  // check this
  Future<void> _saveMenuItem() async {
    if (_menuItem == null) {
      // Add new menu item
      final newMenuItem = MenuItem(
        menuName: _nameController.text,
        icon: _iconController.text,
        isActive: true,
        isParent: false,
        parentId: _parentIdController.text,
        createdAt: DateTime.now(),
        createdBy: _createByController.text,
        updatedAt: DateTime.now(),
        updatedBy: _updateByController.text,
      );
      final newMenuItem0 = await MongoDBService.insertMenuItem(newMenuItem);
      await SQLiteService.insertMenuItem(newMenuItem0!);
    } else {
      // Update the menu item
      final updateMenuItem = MenuItem(
          id: _menuItem!.id,
          menuName: (_nameController.text != _menuItem!.menuName) ? _nameController.text : _menuItem!.menuName,
          icon: (_iconController.text != _menuItem!.icon) ? _iconController.text : null,
          // isActive: true,
          // isParent: false,
          parentId: (_parentIdController.text != _menuItem!.parentId) ? _parentIdController.text : null,
          // createdAt: DateTime.now(),
          createdBy: (_createByController.text != _menuItem!.createdBy) ? _createByController.text : null,
          updatedAt: DateTime.now(),
          updatedBy: (_updateByController.text != _menuItem!.updatedBy) ? _updateByController.text : null);
      await MongoDBService.updateMenuItem(updateMenuItem);
      await SQLiteService.updateMenuItem(updateMenuItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_menuItem != null ? 'Edit MenuItem' : 'Add MenuItem')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _iconController,
              decoration: const InputDecoration(labelText: 'Icon'),
            ),
            TextField(
              controller: _parentIdController,
              decoration: const InputDecoration(labelText: 'ParentId'),
            ),
            TextField(
              controller: _createByController,
              decoration: const InputDecoration(labelText: 'Create by'),
            ),
            TextField(
              controller: _updateByController,
              decoration: const InputDecoration(labelText: 'Update by'),
            ),
            ElevatedButton(
              onPressed: _saveMenuItem,
              child: Text(_menuItem != null ? 'Save Changes' : 'Add MenuItem'),
            ),
          ],
        ),
      ),
    );
  }
}
