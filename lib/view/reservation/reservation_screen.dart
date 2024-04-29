import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/reservation/edit_screen.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_push_profile.dart';
import 'package:restobook_mobile_client/view/shared_widget/info_label.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/table_list_tile.dart';
import 'package:restobook_mobile_client/view/shared_widget/title_future_builder.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';
import 'package:restobook_mobile_client/view_model/reservation_view_model.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../shared_widget/delete_icon_button.dart';
import '../shared_widget/icon_button_navigator_pop.dart';
import '../shared_widget/scaffold_body_padding.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, required this.reservation});

  final Reservation reservation;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late Future<void> reservationLoading;
  late Future<void> tablesLoading;

  @override
  void initState() {
    super.initState();
    reservationLoading =
        Provider.of<ReservationViewModel>(context, listen: false)
            .loadActiveReservation(widget.reservation.id!);
    reservationLoading.then((value) => tablesLoading =
        context.read<ReservationViewModel>().loadActiveReservationTables());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButtonNavigatorPop(),
        title: TitleFutureBuilder(
          loading: reservationLoading,
          errorMessage: const Text("Ошибка загрузки"),
          title: Consumer<ReservationViewModel>(
              builder: (context, reservationViewModel, child) {
            return Text("Бронь ${reservationViewModel.activeReservation?.id!}");
          }),
        ),
        actions: [
          if (context.read<ApplicationViewModel>().isAdmin)
            DeleteIconButton(
              dialogTitle: const Text("Удалить бронь"),
              onSubmit: () {
                return context.read<ReservationViewModel>().delete(
                    context.read<ReservationViewModel>().activeReservation!);
              },
              successLabel: "Бронь удалёна",
              errorLabel: "Не удалось удалить бронь",
            ),
          const IconButtonPushProfile()
        ],
      ),
      body: ScaffoldBodyPadding(
        child: Consumer<ReservationViewModel>(
            builder: (context, reservationViewModel, child) {
          return FutureBuilder(
              future: reservationLoading,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Не удалось загрузить бронь"),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                reservationLoading =
                                    Provider.of<ReservationViewModel>(context,
                                            listen: false)
                                        .loadActiveReservation(
                                            widget.reservation.id!);
                                reservationLoading.then((value) => tablesLoading =
                                    context
                                        .read<ReservationViewModel>()
                                        .loadActiveReservationTables());
                              });
                            },
                            child: const Text("Попробовать ещё раз"))
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Row(
                      children: [
                        InfoLabel(label: "Количество человек:", info: reservationViewModel.activeReservation!.personsNumber.toString())
                      ],
                    ),
                    Row(
                      children: [
                        InfoLabel(label: "Имя клиента:", info: reservationViewModel.activeReservation!.clientName),
                      ],
                    ),
                    Row(
                      children: [
                        InfoLabel(label: "Телефон клиента:", info: reservationViewModel.activeReservation!.clientPhoneNumber),
                      ],
                    ),
                    Row(
                      children: [
                        InfoLabel(
                            label: "Дата и время начала:",
                            info: "${DateFormat.MMMEd("ru_RU").format(reservationViewModel.activeReservation!.startDateTime)} ${DateFormat.Hm("ru_RU").format(reservationViewModel.activeReservation!.startDateTime)}"),
                        // Text(
                        //     "Дата и время начала: ${reservationViewModel.activeReservation?.startDateTime}"),
                      ],
                    ),
                    Row(
                      children: [
                        InfoLabel(label: "Продолжительность:", info: "${reservationViewModel.activeReservation?.durationIntervalMinutes} мин."),
                      ],
                    ),
                    Row(
                      children: [
                        InfoLabel(
                            label: "Сотрудник, открывший бронь:",
                            info: reservationViewModel.activeReservation!.employeeFullName)
                      ],
                    ),
                    Row(
                      children: [
                        InfoLabel(
                            label: "Состояние:",
                            info: switch (reservationViewModel.activeReservation?.state) {
                              "WAITING" => "Ожидает",
                              "OPEN" => "Открыта",
                              "CLOSED" => "Закрыта",
                              String() => throw UnimplementedError(),
                              null => throw UnimplementedError(),
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        InfoLabel(
                            label: "Комментарий:",
                            info: reservationViewModel.activeReservation!.comment ?? "-"),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReservationEditScreen(
                                        reservation: reservationViewModel
                                            .activeReservation!))),
                            child: const Row(
                              children: [
                                Icon(Icons.edit),
                                Text("Редактировать"),
                              ],
                            ))
                      ],
                    ),
                    Expanded(
                      child: RefreshableFutureListView(
                        tablesLoading: tablesLoading,
                        errorLabel: 'Не удалось загрузить столы',
                        onRefresh: () async {
                          var promise = context
                              .read<ReservationViewModel>()
                              .loadActiveReservationTables();
                          setState(() {
                            tablesLoading = promise;
                          });
                          await promise;
                        },
                        listView: ListView.builder(
                            itemCount: reservationViewModel
                                .activeReservationTables.length,
                            itemBuilder: (context, index) => TableListTile(
                                table: reservationViewModel
                                    .activeReservationTables[index])),
                      ),
                    )
                  ],
                );
              });
        }),
      ),
      floatingActionButton: const FloatingCreationReservationButton(),
    );
  }
}
