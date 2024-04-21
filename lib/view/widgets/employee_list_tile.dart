import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/model/employee.dart';

class EmployeeListTile extends StatelessWidget {
  const EmployeeListTile({super.key, required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        title: Text("${employee.surname} ${employee.name} ${employee.patronymic}")
      ),
    );
  }
}