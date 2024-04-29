import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/employees_list.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/reservations_list.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/tables_list.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_push_profile.dart';
import 'package:restobook_mobile_client/view/shared_widget/scaffold_body_padding.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';

import '../../view_model/table_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;
  late Future<void> _tablesLoading;
  bool _dateTimeSelected = false;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  late Timer? _updateTitleTimer;
  late Timer? _updateListTimer;

  @override
  void initState() {
    super.initState();
    loadByTime();
    _updateTitleTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        if (!_dateTimeSelected) {
          _date = DateTime.now();
          _time = TimeOfDay.now();
        }
      });
    });

    _updateListTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        if (_currentScreenIndex == 0) {
          loadByTime();
        }
      });
    });
  }

  @override
  void dispose() {
    _updateTitleTimer?.cancel();
    _updateTitleTimer = null;

    _updateListTimer?.cancel();
    _updateListTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgets;
    List<NavigationDestination> destinations;
    if (context.read<ApplicationViewModel>().isAdmin) {
      bodyWidgets = [
        TablesList(
            tablesLoading: _tablesLoading,
            onRefresh: () async {
              var promise = context.read<TableViewModel>().load();
              setState(() {
                _tablesLoading = promise;
              });
              await promise;
            }),
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
    } else {
      bodyWidgets = [
        TablesList(
            tablesLoading: _tablesLoading,
            onRefresh: () async {
              var promise = context.read<TableViewModel>().load();
              setState(() {
                _tablesLoading = promise;
              });
              await promise;
            }),
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
    }

    var actions = <Widget>[];
    if (_currentScreenIndex == 0) {
      if (_dateTimeSelected) {
        actions.add(IconButton(
            onPressed: () => setCurrentTime(context),
            icon: const Icon(Icons.cancel_outlined)));
      }
      actions.add(IconButton(
          onPressed: () => setDate(context),
          icon: const Icon(Icons.calendar_month)));
      actions.add(IconButton(
          onPressed: () => setTime(context),
          icon: const Icon(Icons.access_time)));
    }
    actions.add(const IconButtonPushProfile());

    Widget title = Text("Restobook");
    if (_currentScreenIndex == 0) {
      title = Column(
        children: [
          const Row(children: [Text("Restobook")]),
          Row(children: [
            Text(
                "${DateFormat.MMMEd("ru_RU").format(_date)} ${_time.format(context)}")
          ])
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: actions,
      ),
      body: ScaffoldBodyPadding(child: bodyWidgets[_currentScreenIndex]),
      floatingActionButton: const FloatingCreationReservationButton(),
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: _currentScreenIndex,
        onDestinationSelected: setDestination,
      ),
    );
  }

  void setDate(BuildContext context) {
    Future<DateTime?> selectedDateTime = showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 31)),
        currentDate: _date);
    selectedDateTime.then((value) => setState(() {
          if (value != null) {
            _date = value;
            _dateTimeSelected = true;
            loadByTime();
          }
        }));
  }

  void setDestination(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  void setCurrentTime(BuildContext context) {
    setState(() {
      _date = DateTime.now();
      _time = TimeOfDay.now();
      _dateTimeSelected = false;
      loadByTime();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Установлено текущее время"),
        duration: Duration(seconds: 1),
      ));
    });
  }

  void setTime(BuildContext context) {
    Future<TimeOfDay?> selectedTime =
        showTimePicker(context: context, initialTime: _time);
    selectedTime.then((value) => setState(() {
          if (value != null) {
            _time = value;
            _dateTimeSelected = true;
            loadByTime();
          }
        }));
  }

  void loadByTime() {
    setState(() {
      _tablesLoading = Provider.of<TableViewModel>(context, listen: false)
          .loadWithDateTime(DateTime(
              _date.year, _date.month, _date.day, _time.hour, _time.minute));
    });
  }
}
