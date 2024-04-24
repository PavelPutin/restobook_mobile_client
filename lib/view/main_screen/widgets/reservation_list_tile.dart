import 'package:flutter/material.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../../reservation/reservation_screen.dart';

class ReservationListTile extends StatelessWidget {
  const ReservationListTile({super.key, required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        title: Text("Бронь номер ${reservation.id}"),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReservationScreen(reservation: reservation))
          );
        },
      ),
    );
  }

}