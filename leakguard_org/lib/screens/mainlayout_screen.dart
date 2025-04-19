import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget child;
  const MainLayoutScreen({super.key, required this.child});

  static final List<String> _routes = [
    '/',
    '/monitoring',
    '/alerts',
    '/manual',
    '/emergency',
    '/user',
  ];

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    for (int i = 0; i < _routes.length; i++) {
      if (location == _routes[i]) {
        return i;
      }
    }

    return 0; // Default to Home if no exact match
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index >= 0 && index < _routes.length) {
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      body: child, // Displays the active screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // Active icon color
        unselectedItemColor: Colors.grey, // Inactive icon color
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Monitor",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Manual"),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: "Emergency"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
        ],
      ),
    );
  }
}
