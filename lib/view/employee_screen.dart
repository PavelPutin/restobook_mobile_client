import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/employee.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_navigator_pop.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_push_profile.dart';
import 'package:restobook_mobile_client/view/shared_widget/title_future_builder.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key, required this.employee});

  final Employee employee;

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  late Future<void> employeeLoading;

  @override
  void initState() {
    super.initState();
    employeeLoading =
        Provider.of<EmployeeViewModel>(context, listen: false).loadById(
            widget.employee.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const IconButtonNavigatorPop(),
          title: TitleFutureBuilder(
            loading: employeeLoading,
            errorMessage: const Text("Ошибка загрузки"),
            title: Consumer<EmployeeViewModel>(
                builder: (context, reservationViewModel, child) {
                  return Text(
                      "${reservationViewModel.activeEmployee?.shortFullName}");
                }),
          ),
          actions: const [IconButtonPushProfile()],
        ),
        floatingActionButton: const FloatingCreationReservationButton(),
        body: Consumer<EmployeeViewModel>(
            builder: (context, reservationViewModel, child) {
              return FutureBuilder(
                  future: employeeLoading,
                  builder: (context, snapshot)
              {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Не удалось загрузить сотрудника"),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                employeeLoading =
                                    Provider.of<EmployeeViewModel>(context, listen: false).loadById(
                                        widget.employee.id!);
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
                        Text(
                            "Имя: ${reservationViewModel.activeEmployee?.name}")
                      ],
                    ),
                    Row(
                      children: [
                        Text("Фамилия: ${reservationViewModel.activeEmployee
                            ?.surname}")
                      ],
                    ),
                    Row(
                      children: [
                        Text("Отчество: ${reservationViewModel.activeEmployee
                            ?.patronymic}")
                      ],
                    ),
                    Row(
                      children: [
                        Text("Комментарий: ${reservationViewModel.activeEmployee
                            ?.comment}")
                      ],
                    ),
                  ],
                );
              });
            })
    );
  }
}