import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/view/employees_screen.dart';
import 'package:restobook_mobile_client/view/reservations_screen.dart';
import 'package:restobook_mobile_client/view/tables_screen.dart';
import 'package:restobook_mobile_client/view/widgets/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/widgets/icon_button_push_profile.dart';

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
        actions: const [IconButtonPushProfile()],
      ),
      body: bodyWidgets[_currentScreenIndex],

      floatingActionButton: const FloatingCreationReservationButton(),
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