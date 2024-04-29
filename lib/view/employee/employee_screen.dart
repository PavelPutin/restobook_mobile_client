import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/entities/employee.dart';
import 'package:restobook_mobile_client/view/employee/edit_screen.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_navigator_pop.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_push_profile.dart';
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
    employeeLoading = Provider.of<EmployeeViewModel>(context, listen: false)
        .loadActiveEmployee(widget.employee.id!);
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
          actions: [
            if (context.read<ApplicationViewModel>().isAdmin)
              DeleteIconButton(
                dialogTitle: const Text("Удалить сотрудника"),
                onSubmit: () {
                  return context.read<EmployeeViewModel>().delete(
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
                                  employeeLoading =
                                      Provider.of<EmployeeViewModel>(context,
                                              listen: false)
                                          .loadActiveEmployee(
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
                          Text("Имя: ${employeeViewModel.activeEmployee?.name}")
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              "Фамилия: ${employeeViewModel.activeEmployee?.surname}")
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              "Отчество: ${employeeViewModel.activeEmployee?.patronymic}")
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              "Комментарий: ${employeeViewModel.activeEmployee?.comment}")
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
