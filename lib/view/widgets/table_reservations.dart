import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view/widgets/reservation_list_tile.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

class TableReservations extends StatefulWidget {
  const TableReservations({super.key});

  @override
  State<TableReservations> createState() => _TableReservationsState();
}

class _TableReservationsState extends State<TableReservations> {
  late Future<void> reservationsLoading;

  @override
  void initState() {
    super.initState();
    reservationsLoading = Provider.of<TableViewModel>(context, listen: false).loadActiveTableReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableViewModel>(
        builder: (context, tableViewModel, child) {
          return RefreshableFutureListView(
            tablesLoading: reservationsLoading,
            onRefresh: () async {
              var promise = context.read<TableViewModel>().loadActiveTableReservations();
              setState(() {
                reservationsLoading = promise;
              });
              await promise;
            },
            errorLabel: "Не удалось загрузить брони",
            listView: ListView.builder(
                itemCount: tableViewModel.activeTableReservations.length,
                itemBuilder: (_, index) => ReservationListTile(reservation: tableViewModel.activeTableReservations[index])
            ),
          );
        }
    );
  }
}