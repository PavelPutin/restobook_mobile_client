import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/employees_list.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/reservations_list.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/tables_list.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_push_profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;
  bool _timeSelected = false;
  TimeOfDay _time = TimeOfDay.now();
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        if (!_timeSelected) {
          _time = TimeOfDay.now();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgets;
    List<NavigationDestination> destinations;
    if (const String.fromEnvironment("USER_TYPE") == "EMPLOYEE") {
      bodyWidgets = [
        const TablesList(),
        const ReservationsList(),
      ];
      destinations = [
        const NavigationDestination(
          icon: Icon(Icons.search),
          label: 'Столы',
        ),
        const NavigationDestination(
          icon: Icon(Icons.ad_units),
          label: 'Брони',
        )
      ];
    } else {
      bodyWidgets = [
        const TablesList(),
        const ReservationsList(),
        const EmployeesList()
      ];
      destinations = [
        const NavigationDestination(
          icon: Icon(Icons.search),
          label: 'Столы',
        ),
        const NavigationDestination(
          icon: Icon(Icons.ad_units),
          label: 'Брони',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Сотрудники',
        )
      ];
    }

    var actions = <Widget>[];
    if (_currentScreenIndex == 0 && _timeSelected) {
      actions.add(IconButton(
          onPressed: () => setCurrentTime(context),
          icon: const Icon(Icons.cancel_outlined)));
    }
    if (_currentScreenIndex == 0) {
      actions.add(IconButton(
          onPressed: () => setTime(context),
          icon: const Icon(Icons.access_time)));
    }
    actions.add(const IconButtonPushProfile());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Row(children: [Text("Restobook")]),
            Row(children: [Text(_time.format(context))])
          ],
        ),
        actions: actions,
      ),
      body: bodyWidgets[_currentScreenIndex],
      floatingActionButton: const FloatingCreationReservationButton(),
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: _currentScreenIndex,
        onDestinationSelected: setDestination,
      ),
    );
  }

  void setDestination(int index) {
        setState(() {
          _currentScreenIndex = index;
        });
      }

  void setCurrentTime(BuildContext context) {
    setState(() {
      _time = TimeOfDay.now();
      _timeSelected = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Установлено текущее время"),
        duration: Duration(seconds: 1),
      ));
    });
  }

  void setTime(BuildContext context) {
    Future<TimeOfDay?> selectedTime = showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    selectedTime.then((value) => setState(() {
      if (value != null) {
        _time = value;
        _timeSelected = true;
      }
    }));
  }
}
