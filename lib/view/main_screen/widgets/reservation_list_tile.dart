import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../../reservation/reservation_screen.dart';

class ReservationListTile extends StatelessWidget {
  const ReservationListTile({super.key, required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    double elevation = reservation.state == "CLOSED" ? 0.1 : 1;
    Color avatarColor = reservation.state == "CLOSED"
        ? Theme.of(context).colorScheme.secondaryContainer
        : Theme.of(context).colorScheme.primaryContainer;
    String state = switch (reservation.state) {
      "WAITING" => "Ожидает",
      "OPEN" => "Открыта",
      "CLOSED" => "Закрыта",
      String() => throw UnimplementedError(),
      null => throw UnimplementedError(),
    };

    return Material(
      child: Card(
        elevation: elevation,
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: avatarColor,
              child: Text("${reservation.personsNumber}")),
          title: Text(
              "${reservation.clientName}, ${reservation.clientPhoneNumber}"),
          subtitle: Text(
              "${DateFormat.MMMEd("ru_RU").format(reservation.startDateTime)} ${DateFormat.Hm().format(reservation.startDateTime)}"),
          trailing: Text(state),
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
