import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_push_profile.dart';
import 'package:restobook_mobile_client/view/table/widgets/reservations.dart';
import 'package:restobook_mobile_client/view/shared_widget/title_future_builder.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../../../view_model/application_view_model.dart';
import '../../../view_model/table_view_model.dart';
import '../../shared_widget/delete_icon_button.dart';
import '../../shared_widget/icon_button_navigator_pop.dart';
import '../../shared_widget/scaffold_body_padding.dart';
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
    int restaurantId = Provider.of<ApplicationViewModel>(context, listen: false)
        .authorizedUser!
        .employee
        .restaurantId!;
    tableLoading = Provider.of<TableViewModel>(context, listen: false)
        .loadActiveTable(restaurantId, widget.table.id!);
  }

  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent(const String.fromEnvironment("open_table_info"));
    List<Widget> bodyWidgets = [
      TableInfo(
          tableLoading: tableLoading,
          onRetry: () async {
            int restaurantId = context
                .read<ApplicationViewModel>()
                .authorizedUser!
                .employee
                .restaurantId!;
            setState(() => tableLoading = context
              .read<TableViewModel>()
              .loadActiveTable(restaurantId, widget.table.id!));
          }),
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
          if (context.read<ApplicationViewModel>().isAdmin)
            DeleteIconButton(
              dialogTitle: const Text("Удалить стол"),
              onSubmit: () {
                AppMetrica.reportEvent(const String.fromEnvironment("delete_table"));
                int restaurantId = context
                    .read<ApplicationViewModel>()
                    .authorizedUser!
                    .employee
                    .restaurantId!;
                return context
                    .read<TableViewModel>()
                    .delete(restaurantId, context.read<TableViewModel>().activeTable!);
              },
              successLabel: "Стол удалён",
              errorLabel: "Не удалось удалить стол",
            ),
          const IconButtonPushProfile()
        ],
      ),
      body: ScaffoldBodyPadding(
        child: bodyWidgets[_currentScreenIndex],
      ),
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
