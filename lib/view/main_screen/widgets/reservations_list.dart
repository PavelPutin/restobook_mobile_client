import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/reservation_list_tile.dart';
import 'package:restobook_mobile_client/view_model/reservation_view_model.dart';

class ReservationsList extends StatefulWidget {
  const ReservationsList({super.key});

  @override
  State<ReservationsList> createState() => _ReservationsListState();
}

class _ReservationsListState extends State<ReservationsList> {
  late Future<void> reservationsLoading;

  @override
  void initState() {
    super.initState();
    reservationsLoading = Provider.of<ReservationViewModel>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationViewModel>(
        builder: (context, reservationViewModel, child) {
          return RefreshableFutureListView(
            tablesLoading: reservationsLoading,
            onRefresh: () async {
              var promise = context.read<ReservationViewModel>().load();
              setState(() {
                reservationsLoading = promise;
              });
              await promise;
            },
            errorLabel: "Не удалось загрузить брони",
            listView: ListView.builder(
                itemCount: reservationViewModel.reservations.length,
                itemBuilder: (_, index) => ReservationListTile(reservation: reservationViewModel.reservations[index])
            ),
          );
        }
    );
  }
}