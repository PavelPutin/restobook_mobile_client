import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/employee_list_tile.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';

import '../../employee/creation_screen.dart';

class EmployeesList extends StatefulWidget {
  const EmployeesList({super.key});

  @override
  State<EmployeesList> createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
  late Future<void> employeesLoading;
  final logger = GetIt.I<Logger>();

  @override
  void initState() {
    super.initState();
    logger.t("Init employee screen");
    int restaurantId = Provider.of<ApplicationViewModel>(context, listen: false).authorizedUser!.employee.restaurantId!;
    // int restaurantId = 0;
    employeesLoading =
        Provider.of<EmployeeViewModel>(context, listen: false).load(restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeViewModel>(
        builder: (context, employeeViewModel, child) {
      bool isAdmin = context.read<ApplicationViewModel>().isAdmin;
      var itemCount = employeeViewModel.employees.length;
      if (isAdmin) {
        itemCount += 1;
      }

      return RefreshableFutureListView(
        tablesLoading: employeesLoading,
        onRefresh: () async {
          // int restaurantId = 0;
          int restaurantId = context.read<ApplicationViewModel>().authorizedUser!.employee.restaurantId!;
          var promise = context.read<EmployeeViewModel>().load(restaurantId);
          setState(() {
            employeesLoading = promise;
          });
          await promise;
        },
        errorLabel: "Не удалось загрузить сотрудников",
        listView: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (_, index) {
              if (index == employeeViewModel.employees.length && isAdmin) {
                return ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmployeeCreationScreen())),
                    child: const Text("Добавить сотрудника"));
              }

              return EmployeeListTile(
                  employee: employeeViewModel.employees[index]);
            }),
      );
    });
  }
}
