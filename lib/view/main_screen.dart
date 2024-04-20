import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/view/employees_screen.dart';
import 'package:restobook_mobile_client/view/profile_screen.dart';
import 'package:restobook_mobile_client/view/reservation_screen.dart';
import 'package:restobook_mobile_client/view/tables_screan.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgets;
    List<NavigationDestination> destinations;
    if (const String.fromEnvironment("USER_TYPE") == "EMPLOYEE") {
      bodyWidgets = [
        const TablesScreen(),
        const ReservationsScreen(),
      ];
      destinations = [
        const NavigationDestination(icon: Icon(Icons.search), label: 'Столы',),
        const NavigationDestination(icon: Icon(Icons.ad_units), label: 'Брони',)
      ];
    } else {
      bodyWidgets = [
        const TablesScreen(),
        const ReservationsScreen(),
        const EmployeesScreen()
      ];
      destinations = [
        const NavigationDestination(icon: Icon(Icons.search), label: 'Столы',),
        const NavigationDestination(icon: Icon(Icons.ad_units), label: 'Брони',),
        const NavigationDestination(icon: Icon(Icons.person), label: 'Сотрудники',)
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restobook"),
        actions: [
          IconButton(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen())
                )
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: bodyWidgets[_currentScreenIndex],
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: _currentScreenIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
      ),
    );
  }
}