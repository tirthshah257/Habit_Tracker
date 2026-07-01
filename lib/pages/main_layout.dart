import 'package:flutter/material.dart';
import 'home_page.dart';
import 'add_habit_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AddHabitPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Beautiful gradient Add Button
    final Widget premiumAddButton = Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purpleAccent, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          setState(() {
            _selectedIndex = 1; // Go to Add Habit tab
          });
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50], // Slightly off-white for premium feel
      body: Row(
        children: [
          // If on wide screen (Chrome Web/Desktop), show a NavigationRail
          if (MediaQuery.of(context).size.width >= 600)
            NavigationRail(
              backgroundColor: Colors.white,
              elevation: 4,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              selectedLabelTextStyle: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
              selectedIconTheme: const IconThemeData(color: Colors.deepPurple),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: premiumAddButton,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(Icons.add_circle),
                  label: Text('Add Habit'),
                ),
              ],
            ),
          
          // The main content area
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
      // If on narrow screen (Mobile), show BottomNavigationBar
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                elevation: 0,
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedItemColor: Colors.deepPurple,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined),
                    activeIcon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle_outline),
                    activeIcon: Icon(Icons.add_circle),
                    label: 'Add Habit',
                  ),
                ],
              ),
            )
          : null,
      floatingActionButton: MediaQuery.of(context).size.width < 600 && _selectedIndex == 0
          ? premiumAddButton
          : null,
    );
  }
}
