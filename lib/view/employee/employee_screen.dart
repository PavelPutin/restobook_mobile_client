import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/entities/employee.dart';
import 'package:restobook_mobile_client/view/employee/edit_screen.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_navigator_pop.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_push_profile.dart';
import 'package:restobook_mobile_client/view/shared_widget/info_label.dart';
import 'package:restobook_mobile_client/view/shared_widget/title_future_builder.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';

import '../../view_model/application_view_model.dart';
import '../shared_widget/delete_icon_button.dart';
import '../shared_widget/scaffold_body_padding.dart';

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
    int restaurantId = Provider.of<ApplicationViewModel>(context, listen: false).authorizedUser!.employee.restaurantId!;
    employeeLoading = Provider.of<EmployeeViewModel>(context, listen: false)
        .loadActiveEmployee(restaurantId, widget.employee.id!);
  }

  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent(const String.fromEnvironment("open_employee_info"));
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
          actions: [
            if (context.read<ApplicationViewModel>().isAdmin)
              DeleteIconButton(
                dialogTitle: const Text("Удалить сотрудника"),
                onSubmit: () {
                  AppMetrica.reportEvent(const String.fromEnvironment("delete_employee"));
                  int restaurantId = context
                      .read<ApplicationViewModel>()
                      .authorizedUser!
                      .employee
                      .restaurantId!;
                  return context.read<EmployeeViewModel>().delete(
                      restaurantId,
                      context.read<EmployeeViewModel>().activeEmployee!);
                },
                successLabel: "Сотрудник удалён",
                errorLabel: "Не удалось удалить сотрудника",
              ),
            const IconButtonPushProfile()
          ],
        ),
        floatingActionButton: const FloatingCreationReservationButton(),
        body: ScaffoldBodyPadding(
          child: Consumer<EmployeeViewModel>(
              builder: (context, employeeViewModel, child) {
            return FutureBuilder(
                future: employeeLoading,
                builder: (context, snapshot) {
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
                                  int restaurantId = Provider.of<ApplicationViewModel>(context, listen: false).authorizedUser!.employee.restaurantId!;
                                  employeeLoading =
                                      Provider.of<EmployeeViewModel>(context,
                                              listen: false)
                                          .loadActiveEmployee(
                                          restaurantId, widget.employee.id!);
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
                          InfoLabel(label: "Имя:", info: employeeViewModel.activeEmployee!.name)
                        ],
                      ),
                      Row(
                        children: [
                          InfoLabel(label: "Фамилия:", info: employeeViewModel.activeEmployee!.surname)
                        ],
                      ),
                      Row(
                        children: [
                          InfoLabel(label: "Отчество:", info: employeeViewModel.activeEmployee!.patronymic ?? "-")
                        ],
                      ),
                      Row(
                        children: [
                          InfoLabel(label: "Комментарий:", info: employeeViewModel.activeEmployee?.comment ?? "-")
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmployeeEditScreen(
                                            employee:
                                                employeeViewModel.activeEmployee!,
                                          ))),
                              child: const Row(
                                children: [
                                  Icon(Icons.edit),
                                  Text("Редактировать"),
                                ],
                              ))
                        ],
                      )
                    ],
                  );
                });
          }),
        ));
  }
}
