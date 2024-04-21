import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/widgets/reservation_list_tile.dart';
import 'package:restobook_mobile_client/view_model/reservation_view_model.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  late Future<void> tablesLoading;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    tablesLoading = Provider.of<ReservationViewModel>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationViewModel>(
        builder: (context, reservationViewModel, child) {
          return RefreshIndicator(
            onRefresh: () async {
              var promise = context.read<ReservationViewModel>().load();
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
                                    context.read<ReservationViewModel>().load();
                              });
                            },
                            child: const Text("Попробовать ещё раз"))
                      ],
                    ),
                  );
                }

                return ListView.builder(
                    itemCount: reservationViewModel.reservations.length,
                    itemBuilder: (_, index) => ReservationListTile(reservation: reservationViewModel.reservations[index])
                );
              },
            ),
          );
        }
    );
  }
}