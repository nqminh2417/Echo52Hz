import 'package:flutter/material.dart';

import '../models/menu_item.dart';

class MenuProvider extends ChangeNotifier {
  // Example: Current active menu index
  int _currentIndex = 0;

  // Getter for the current active index
  int get currentIndex => _currentIndex;

  // Function to change the menu index
  void setMenuIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Notify all listeners when the index changes
  }

  List<MenuItem> _menuItems = [];

  List<MenuItem> get menuItems => _menuItems;

  void setMenuItems(List<MenuItem> items) {
    _menuItems = items;
    notifyListeners();
  }

  // * You can also add more menu-related states here like visibility toggles, etc.

  // Example: Toggle menu visibility
  // bool _isMenuVisible = true;

  // bool get isMenuVisible => _isMenuVisible;

  // void toggleMenuVisibility() {
  //   _isMenuVisible = !_isMenuVisible;
  //   notifyListeners(); // Notify listeners of the change
  // }
}
