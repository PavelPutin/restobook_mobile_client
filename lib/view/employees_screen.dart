import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/widgets/employee_list_tile.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  late Future<void> tablesLoading;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    tablesLoading = Provider.of<EmployeeViewModel>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeViewModel>(
        builder: (context, employeeViewModel, child) {
          return RefreshIndicator(
            onRefresh: () async {
              var promise = context.read<EmployeeViewModel>().load();
              setState(() {
                _refreshing = true;
                tablesLoading = promise;
              });
              await promise;
            },
            child: FutureBuilder(
              future: tablesLoading,
              builder: (ctx, snapshot) {
                if (!_refreshing && snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Не удалось загрузить сотрудников"),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _refreshing = false;
                                tablesLoading =
                                    context.read<EmployeeViewModel>().load();
                              });
                            },
                            child: const Text("Попробовать ещё раз"))
                      ],
                    ),
                  );
                }

                return ListView.builder(
                    itemCount: employeeViewModel.employees.length,
                    itemBuilder: (_, index) => EmployeeListTile(employee: employeeViewModel.employees[index])
                );
              },
            ),
          );
        }
    );
  }
}