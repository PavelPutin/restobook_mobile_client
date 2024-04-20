import 'package:flutter/material.dart';

import '../../model/reservation.dart';

class ReservationListTile extends StatelessWidget {
  const ReservationListTile({super.key, required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      title: Text("Бронь номер ${reservation.id}"),
    );
  }

}