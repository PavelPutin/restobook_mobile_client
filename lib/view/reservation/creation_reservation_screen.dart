import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/view/reservation/reservation_screen.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/client_name_textfield.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/client_phone_number_textfield.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/duration_interval_minutes_textfield.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/persons_number_textfield.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/start_date_field.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/start_time_field.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/table_selection_chips_field.dart';
import 'package:restobook_mobile_client/view/shared_widget/comment_text_field.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';
import 'package:restobook_mobile_client/view_model/reservation_view_model.dart';

import '../shared_widget/scaffold_body_padding.dart';
import '../shared_widget/scrollable_expanded.dart';

class CreationReservationScreen extends StatefulWidget {
  const CreationReservationScreen({super.key});

  @override
  State<CreationReservationScreen> createState() =>
      _CreationReservationScreenState();
}

class _CreationReservationScreenState extends State<CreationReservationScreen> {
  late Future<void> submiting;
  final _reservationCreatingFormKey = GlobalKey<FormState>();

  final TextEditingController _personsNumberController =
      TextEditingController();
  final _clientPhoneNumberController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _startTimeController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay.now();
  final _startDateController = TextEditingController();
  DateTime _startDate = DateTime.now();

  final _durationIntervalMinutesController = TextEditingController();

  List<TableModel> tables = [];

  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    submiting = Future.delayed(const Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Новая бронь")),
      body: ScaffoldBodyPadding(
        child: ScrollableExpanded(
          child: Form(
            key: _reservationCreatingFormKey,
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
                  child: TableSelectionChipsField(
                    tables: tables,
                    targetDateTime: DateTime(_startDate.year, _startDate.month,
                        _startDate.day, _startTime.hour, _startTime.minute),
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
    if (_reservationCreatingFormKey.currentState!.validate()) {
      // update reservation
      List<int> tableIds = [];
      for (var t in tables) {
        tableIds.add(t.id!);
      }
      var created = Reservation(
          null,
          int.parse(_personsNumberController.text),
          _clientPhoneNumberController.text,
          _clientNameController.text,
          DateTime(_startDate.year, _startDate.month, _startDate.day,
              _startTime.hour, _startTime.minute),
          int.parse(_durationIntervalMinutesController.text),
          context.read<ApplicationViewModel>().authorizedUser!.employee.shortFullName,
          DateTime.now(),
          "WAITING",
          _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
          context.read<ApplicationViewModel>().authorizedUser?.employee.restaurantId,
          tableIds);

      setState(() {
        int restaurantId = context
            .read<ApplicationViewModel>()
            .authorizedUser!
            .employee
            .restaurantId!;
        submiting = context.read<ReservationViewModel>().add(restaurantId, created, tables);
        submiting.then((value) {
          AppMetrica.reportEvent(const String.fromEnvironment("create_reservation"));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ReservationScreen(
                      reservation: context
                          .read<ReservationViewModel>()
                          .activeReservation!)));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Бронь успешно создана")));
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Не удалось создать бронь")));
        });
      });
    }
  }
}
