import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/employee_list_tile.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';

import '../../employee/creation_screen.dart';

class EmployeesList extends StatefulWidget {
  const EmployeesList({super.key});

  @override
  State<EmployeesList> createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
  late Future<void> employeesLoading;

  @override
  void initState() {
    super.initState();
    employeesLoading =
        Provider.of<EmployeeViewModel>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeViewModel>(
        builder: (context, employeeViewModel, child) {
      bool isAdmin = const String.fromEnvironment("USER_TYPE") == "ADMIN";
      var itemCount = employeeViewModel.employees.length;
      if (isAdmin) {
        itemCount += 1;
      }

      return RefreshableFutureListView(
        tablesLoading: employeesLoading,
        onRefresh: () async {
          var promise = context.read<EmployeeViewModel>().load();
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
