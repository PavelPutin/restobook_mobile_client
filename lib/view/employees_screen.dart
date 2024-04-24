import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/widgets/employee_list_tile.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  late Future<void> employeesLoading;

  @override
  void initState() {
    super.initState();
    employeesLoading = Provider.of<EmployeeViewModel>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeViewModel>(
        builder: (context, employeeViewModel, child) {
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
                itemCount: employeeViewModel.employees.length,
                itemBuilder: (_, index) => EmployeeListTile(employee: employeeViewModel.employees[index])
            ),
          );
        }
    );
  }
}