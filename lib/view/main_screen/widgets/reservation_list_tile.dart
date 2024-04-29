import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../../reservation/reservation_screen.dart';

class ReservationListTile extends StatelessWidget {
  const ReservationListTile({super.key, required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: ListTile(
          leading: CircleAvatar(child: Text("${reservation.personsNumber}")),
          title: Text(
              "${reservation.clientName}, ${reservation.clientPhoneNumber}"),
          subtitle: Text(
              "${DateFormat.MMMEd("ru_RU").format(reservation.startDateTime)} ${DateFormat.Hm().format(reservation.startDateTime)}"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ReservationScreen(reservation: reservation)));
          },
        ),
      ),
    );
  }
}
