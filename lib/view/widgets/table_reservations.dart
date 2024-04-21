import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/widgets/reservation_list_tile.dart';
import 'package:restobook_mobile_client/view_model/reservation_view_model.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

class TableReservations extends StatefulWidget {
  const TableReservations({super.key});

  @override
  State<TableReservations> createState() => _TableReservationsState();
}

class _TableReservationsState extends State<TableReservations> {
  late Future<void> tablesLoading;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    tablesLoading = Provider.of<TableViewModel>(context, listen: false).loadActiveTableReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableViewModel>(
        builder: (context, tableViewModel, child) {
          return RefreshIndicator(
            onRefresh: () async {
              var promise = context.read<TableViewModel>().loadActiveTableReservations();
              setState(() {
                _refreshing = true;
                tablesLoading = promise;
              });
              await promise;
            },
            child: FutureBuilder(
              future: tablesLoading,
              builder: (ctx, snapshot) {
                if (!_refreshing && snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Не удалось загрузить брони"),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _refreshing = false;
                                tablesLoading =
                                    context.read<TableViewModel>().loadActiveTableReservations();
                              });
                            },
                            child: const Text("Попробовать ещё раз"))
                      ],
                    ),
                  );
                }

                return ListView.builder(
                    itemCount: tableViewModel.activeTableReservations.length,
                    itemBuilder: (_, index) => ReservationListTile(reservation: tableViewModel.activeTableReservations[index])
                );
              },
            ),
          );
        }
    );
  }
}