import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/widgets/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/widgets/icon_button_push_profile.dart';
import 'package:restobook_mobile_client/view/widgets/table_reservations.dart';
import 'package:restobook_mobile_client/view/widgets/table_title_future_builder.dart';

import '../model/table_model.dart';
import '../view_model/table_view_model.dart';
import 'widgets/icon_button_navigtor_pop.dart';
import 'widgets/table_info.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key, required this.table});

  final TableModel table;

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  int _currentScreenIndex = 0;
  late Future<void> tableLoading;

  @override
  void initState() {
    super.initState();
    tableLoading = Provider.of<TableViewModel>(context, listen: false).loadById(widget.table.id!);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgets = [
      TableInfo(
        tableLoading: tableLoading,
        onRetry: () async =>
          setState(() =>
            tableLoading =
                context.read<TableViewModel>().loadById(widget.table.id!)
          )
      ),
      const TableReservations()
    ];
    return Scaffold(
      appBar: AppBar(
        leading: const IconButtonNavigatorPop(),
        title: TableTitleFutureBuilder(tableLoading: tableLoading),
        actions: const [IconButtonPushProfile()],
      ),
      body: bodyWidgets[_currentScreenIndex],
      floatingActionButton: const FloatingCreationReservationButton(),
      bottomNavigationBar: FutureBuilder(
        future: tableLoading,
        builder: (context, snapshot) {
          bool reservationScreenEnable =
            snapshot.connectionState != ConnectionState.waiting &&
            !snapshot.hasError;
          return NavigationBar(
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.info_outline),
                label: "О столе"
              ),
              NavigationDestination(
                icon: const Icon(Icons.ad_units),
                label: "Брони",
                enabled: reservationScreenEnable,
              ),
            ],
            selectedIndex: _currentScreenIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentScreenIndex = index;
              });
            },
          );
        }
      ),
    );
  }
}