import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/model/employee.dart';

import '../employee_screen.dart';

class EmployeeListTile extends StatelessWidget {
  const EmployeeListTile({super.key, required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        title: Text("${employee.surname} ${employee.name} ${employee.patronymic}"),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeeScreen(employee: employee,)
              )
          )
        },
      ),
    );
  }
}