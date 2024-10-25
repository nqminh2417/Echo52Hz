// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/menu_bloc.dart';
import '../models/menu_item.dart';
import '../providers/menu_provider.dart';
import '../utils/string_utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // late MenuProvider menuProvider;

  late MenuBloc _menuBloc;
  List<MenuItem> _menuItems = [];
  List<MenuItem> p_Items = [];
  List<MenuItem> c_Items = [];

  @override
  void initState() {
    super.initState();
    // menuProvider = Provider.of<MenuProvider>(context, listen: false);

    // Access the MenuBloc
    _menuBloc = BlocProvider.of<MenuBloc>(context);

    // Trigger the loading of menu items for 'ADMIN'
    // _menuBloc.add(LoadMenuItemsEvent(roleCode: 'ADMIN'));

    // Listen for bloc state changes and update UI accordingly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _menuItems = _menuBloc.menuItems;
        p_Items = _menuItems.where((item) => item.isParent!).toList()..sort((a, b) => a.orderId!.compareTo(b.orderId!));
        c_Items = _menuItems.where((item) => !item.isParent!).toList()..sort((a, b) => a.orderId!.compareTo(b.orderId!));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final menuItems = menuProvider.menuItems;
    // final p_Items = menuItems.where((item) => item.isParent!).toList()..sort((a, b) => a.orderId!.compareTo(b.orderId!));
    // final c_Items = menuItems.where((item) => !item.isParent!).toList()..sort((a, b) => a.orderId!.compareTo(b.orderId!));
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
          SingleChildScrollView(
            child: Column(
              children: [
                _MenuLevelOne(p_Items, c_Items),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.sync),
                  title: const Text('Sync data'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log out'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _MenuLevelOne(List<MenuItem> parentItems, List<MenuItem> childItems) {
    final expansionPanelItems = parentItems.map<ExpansionPanel>((item) {
      final children = _MenuLevelTwo(item.id!, childItems);
      return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return ListTile(
            title: Text(item.menuName),
            onTap: () {
              setState(() {
                item.isExpanded = !item.isExpanded;
              });
            },
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
          parentItems[index].isExpanded = isExpanded;
        });
      },
      children: expansionPanelItems,
    );
  }

  List<Widget> _MenuLevelTwo(String parentId, List<MenuItem> childItems) {
    final children = <Widget>[];

    for (final childItem in childItems) {
      if (!childItem.isParent! && childItem.parentId == parentId) {
        children.add(
          ListTile(
            // leading: Icon(childItem.icon),
            title: Text(childItem.menuName),
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
