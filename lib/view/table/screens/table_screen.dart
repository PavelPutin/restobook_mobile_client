import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_push_profile.dart';
import 'package:restobook_mobile_client/view/table/widgets/reservations.dart';
import 'package:restobook_mobile_client/view/shared_widget/title_future_builder.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../../../view_model/table_view_model.dart';
import '../../shared_widget/delete_alert_dialog.dart';
import '../../shared_widget/delete_icon_button.dart';
import '../../shared_widget/icon_button_navigator_pop.dart';
import '../widgets/info.dart';

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
    tableLoading = Provider.of<TableViewModel>(context, listen: false)
        .loadActiveTable(widget.table.id!);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgets = [
      TableInfo(
          tableLoading: tableLoading,
          onRetry: () async => setState(() => tableLoading = context
              .read<TableViewModel>()
              .loadActiveTable(widget.table.id!))),
      const TableReservations()
    ];
    return Scaffold(
      appBar: AppBar(
        leading: const IconButtonNavigatorPop(),
        // title: TableTitleFutureBuilder(tableLoading: tableLoading),
        title: TitleFutureBuilder(
          loading: tableLoading,
          errorMessage: const Text("Ошибка загрузки"),
          title: Consumer<TableViewModel>(
              builder: (context, tableViewModel, child) {
            return Text("Стол ${tableViewModel.activeTable?.number}");
          }),
        ),
        actions: [
          DeleteIconButton(
            dialogTitle: const Text("Удалить стол"),
            onSubmit: () {
              return context
                  .read<TableViewModel>()
                  .delete(context.read<TableViewModel>().activeTable!);
            },
            successLabel: "Стол удалён",
            errorLabel: "Не удалось удалить стол",
          ),
          const IconButtonPushProfile()
        ],
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
                    icon: Icon(Icons.info_outline), label: "О столе"),
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
          }),
    );
  }
}
