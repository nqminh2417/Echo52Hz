import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../more/more_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Index to track the selected tab

  // Define the screens you want to show in the BottomNavigationBar
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    MoreScreen(),
    // SettingsScreen(),
  ];

  // Function to handle the tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show the current tab content here
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Selected tab color
        onTap: _onItemTapped, // Call the function when a tab is selected
      ),
    );
  }
}
