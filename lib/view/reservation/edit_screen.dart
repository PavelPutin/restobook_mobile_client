import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/client_name_textfield.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/client_phone_number_textfield.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/duration_interval_minutes_textfield.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/persons_number_textfield.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/start_date_field.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/start_time_field.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/table_selection_chips_field.dart';
import 'package:restobook_mobile_client/view/shared_widget/comment_text_field.dart';
import 'package:restobook_mobile_client/view_model/reservation_view_model.dart';

import '../shared_widget/scaffold_body_padding.dart';
import '../shared_widget/title_future_builder.dart';
import '../table/widgets/scrollable_expanded_future_builder.dart';
import 'widgets/reservation_state_dropdown_menu.dart';

class ReservationEditScreen extends StatefulWidget {
  const ReservationEditScreen({super.key, required this.reservation});

  final Reservation reservation;

  @override
  State<ReservationEditScreen> createState() => _ReservationEditScreenState();
}

class _ReservationEditScreenState extends State<ReservationEditScreen> {
  late Future<void> loading;
  late Future<void> submiting;
  final _reservationEditingFormKey = GlobalKey<FormState>();

  final TextEditingController _personsNumberController =
      TextEditingController();
  final _clientPhoneNumberController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _startTimeController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay.now();
  final _startDateController = TextEditingController();
  DateTime _startDate = DateTime.now();

  final _durationIntervalMinutesController = TextEditingController();
  String _selectedState = "WAITING";

  List<TableModel> tables = [];

  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    submiting = Future.delayed(const Duration(seconds: 0));
    loading = Provider.of<ReservationViewModel>(context, listen: false)
        .loadActiveReservation(widget.reservation.id!);
    loading.then((value) {
      setState(() {
        var personsNumber =
            Provider.of<ReservationViewModel>(context, listen: false)
                .activeReservation!
                .personsNumber
                .toString();
        _personsNumberController.value = TextEditingValue(text: personsNumber);

        var phoneNumber =
            Provider.of<ReservationViewModel>(context, listen: false)
                .activeReservation!
                .clientPhoneNumber;
        _clientPhoneNumberController.value =
            TextEditingValue(text: phoneNumber);

        var clientName =
            Provider.of<ReservationViewModel>(context, listen: false)
                .activeReservation!
                .clientName;

        _clientNameController.value = TextEditingValue(text: clientName);

        var startDateTime =
            Provider.of<ReservationViewModel>(context, listen: false)
                .activeReservation!
                .startDateTime;
        _startTime = TimeOfDay.fromDateTime(startDateTime);
        _startTimeController.value =
            TextEditingValue(text: _startTime.format(context));

        _startDate = startDateTime;
        _startDateController.value = TextEditingValue(
            text: DateFormat.yMMMMd("ru_RU").format(_startDate));

        var duration = Provider.of<ReservationViewModel>(context, listen: false)
            .activeReservation!
            .durationIntervalMinutes
            .toString();
        _durationIntervalMinutesController.value =
            TextEditingValue(text: duration);

        _selectedState =
            Provider.of<ReservationViewModel>(context, listen: false)
                .activeReservation!
                .state!;

        tables = List.from(
            Provider.of<ReservationViewModel>(context, listen: false)
                .activeReservationTables);

        String? comment =
            Provider.of<ReservationViewModel>(context, listen: false)
                .activeReservation!
                .comment;
        _commentController.value = TextEditingValue(text: comment ?? "");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TitleFutureBuilder(
              loading: loading,
              errorMessage: const Text("Ошибка загрузки"),
              title: Consumer<ReservationViewModel>(
                  builder: (context, tableViewModel, child) {
                return Text("Бронь ${tableViewModel.activeReservation?.id}");
              }))),
      body: ScaffoldBodyPadding(
        child: ScrollableExpandedFutureBuilder(
          loading: loading,
          onRefresh: () async => setState(() => loading = context
              .read<ReservationViewModel>()
              .loadActiveReservation(widget.reservation.id!)),
          errorLabel: const Text("Не удалось загрузить бронь"),
          child: Form(
            key: _reservationEditingFormKey,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: PersonsNumberTextField(controller: _personsNumberController)
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ClientPhoneNumberTextField(
                      controller: _clientPhoneNumberController),
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ClientNameTextField(controller: _clientNameController)
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: StartTimeField(
                    controller: _startTimeController,
                    initialTime: _startTime,
                    blockEditing: () => _startTimeController.value =
                        TextEditingValue(text: _startTime.format(context)),
                    onChange: (TimeOfDay? value) => setState(() {
                      if (value != null) {
                        _startTime = value;
                        _startTimeController.value =
                            TextEditingValue(text: _startTime.format(context));
                      }
                    }),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: StartDateField(
                      controller: _startDateController,
                      blockEditing: () => _startTimeController.value =
                          TextEditingValue(text: _startTime.format(context)),
                      onChange: (DateTime? value) => setState(() {
                            if (value != null) {
                              _startDate = value;
                              _startDateController.value = TextEditingValue(
                                  text: DateFormat.yMMMMd("ru_RU")
                                      .format(_startDate));
                            }
                          })),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: DurationIntervalMinutesTextField(
                      controller: _durationIntervalMinutesController),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ReservationStateDropdownMenu(
                    initialValue: _selectedState,
                    onChanged: (value) => setState(() => _selectedState = value),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TableSelectionChipsField(
                    tables: tables,
                    targetDateTime: DateTime(
                        _startDate.year,
                        _startDate.month,
                        _startDate.day,
                        _startTime.hour,
                        _startTime.minute),
                    onDeleted: (value) => setState(() {
                      tables.remove(value);
                    }),
                    onSelected: (values) => setState(() {
                      tables.addAll(values);
                    }),

                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: CommentTextField(controller: _commentController)
                ),
                ElevatedButton(
                    onPressed: submit,
                    child: FutureBuilder(
                        future: submiting,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          return const Text("Применить");
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() async {
    if (_reservationEditingFormKey.currentState!.validate()) {
      // update reservation
      Reservation source =
          context.read<ReservationViewModel>().activeReservation!;
      List<int> tableIds = [];
      for (var t in tables) {
        tableIds.add(t.id!);
      }
      var updated = Reservation(
          source.id,
          int.parse(_personsNumberController.text),
          _clientPhoneNumberController.text,
          _clientNameController.text,
          DateTime(_startDate.year, _startDate.month, _startDate.day,
              _startTime.hour, _startTime.minute),
          int.parse(_durationIntervalMinutesController.text),
          source.employeeFullName,
          source.creatingDateTime,
          _selectedState,
          _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
          source.restaurantId,
          tableIds);

      setState(() {
        submiting = context.read<ReservationViewModel>().update(updated);
        submiting.then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Бронь успешно обновлёна")));
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Не удалось изменить бронь")));
        });
      });
    }
  }
}
