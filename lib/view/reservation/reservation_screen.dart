import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_push_profile.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/table_list_tile.dart';
import 'package:restobook_mobile_client/view/shared_widget/title_future_builder.dart';
import 'package:restobook_mobile_client/view_model/reservation_view_model.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../shared_widget/icon_button_navigator_pop.dart';

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
        Provider.of<ReservationViewModel>(context, listen: false).loadActiveReservation(widget.reservation.id!);
    reservationLoading.then((value) => tablesLoading = context.read<ReservationViewModel>().loadActiveReservationTables());
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
        actions: const [IconButtonPushProfile()],
      ),
      body: Consumer<ReservationViewModel>(
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
                                  Provider.of<ReservationViewModel>(context, listen: false).loadActiveReservation(widget.reservation.id!);
                                reservationLoading.then((value) => tablesLoading = context.read<ReservationViewModel>().loadActiveReservationTables());
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
                          Text("Количество человек: ${reservationViewModel.activeReservation?.personsNumber}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Имя клиента: ${reservationViewModel.activeReservation?.clientName}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Телефон клиента: ${reservationViewModel.activeReservation?.clientPhoneNumber}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Дата и время начала: ${reservationViewModel.activeReservation?.startDateTime}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Продолжительность: ${reservationViewModel.activeReservation?.durationIntervalMinutes} мин."),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Сотрудник, открывший бронь: ${reservationViewModel.activeReservation?.employeeFullName}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Состояние: ${reservationViewModel.activeReservation?.state}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Комментарий: ${reservationViewModel.activeReservation?.comment}"),
                        ],
                      ),
                      Expanded(
                        child: RefreshableFutureListView(
                          tablesLoading: tablesLoading,
                          errorLabel: 'Не удалось загрузить столы',
                          onRefresh: () async {
                            var promise = context.read<ReservationViewModel>().loadActiveReservationTables();
                            setState(() {
                              tablesLoading = promise;
                            });
                            await promise;
                          },
                          listView: ListView.builder(
                              itemCount: reservationViewModel.activeReservationTables.length,
                              itemBuilder: (context, index) => TableListTile(table: reservationViewModel.activeReservationTables[index])
                          ),
                        ),
                      )
                    ],
                  );
                });
          }
      ),
      floatingActionButton: const FloatingCreationReservationButton(),
    );
  }
}