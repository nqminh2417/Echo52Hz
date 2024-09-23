// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/menu_bloc.dart';
import '../models/menu_item.dart';
import '../services/sqlite_service.dart';
import '../utils/string_utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  List<MenuItem> _parentItems = [];
  List<MenuItem> _childItems = [];
  @override
  void initState() {
    super.initState();
    getMenu();
  }

  Future<void> getMenu() async {
    final menuItems = await SQLiteService.getMenuItemsByRoleCode('ADMIN');
    final parentItems = menuItems.where((item) => item.isParent!).toList()..sort((a, b) => a.orderId!.compareTo(b.orderId!));
    StringUtils.debugLog(parentItems);
    final childItems = menuItems.where((item) => !item.isParent!).toList()..sort((a, b) => a.orderId!.compareTo(b.orderId!));
    StringUtils.debugLog(childItems);

    setState(() {
      _parentItems = parentItems;
      _childItems = childItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final menuBloc = context.read<MenuBloc>();
    // final menuItems = menuBloc.state.
    
    return Drawer(
      child: SafeArea(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          InkWell(
            child: Container(
              height: 200,
              color: Colors.amber,
            ),
          ),
          _MenuLevelOne(_parentItems, _childItems),
        ],
      )),
    );
  }

  Widget _MenuLevelOne(List<MenuItem> parentItems, List<MenuItem> childItems) {
    final expansionPanelItems = parentItems.map<ExpansionPanel>((item) {
      final children = _buildChildListTiles(item.id, childItems);
      return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return ListTile(
            title: Text(item.menuName!),
          );
        },
        body: Column(children: children),
        isExpanded: item.isExpanded,
      );
    }).toList();

    return ExpansionPanelList(
      elevation: 0,
      dividerColor: Colors.transparent,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          parentItems[index].isExpanded = !isExpanded;
        });
      },
      children: expansionPanelItems,
    );
  }

  List<Widget> _buildChildListTiles(String parentId, List<MenuItem> childItems) {
    final children = <Widget>[];

    for (final childItem in childItems) {
      if (!childItem.isParent! && childItem.parentId == parentId) {
        children.add(
          ListTile(
            // leading: Icon(childItem.icon),
            title: Text(childItem.menuName!),
            onTap: () {
              // Handle the onTap action
              // Navigator.popAndPushNamed(context, childItem.route);
            },
          ),
        );
      }
    }
    return children;
  }
}
