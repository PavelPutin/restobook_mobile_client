import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/entities/employee.dart';
import 'package:restobook_mobile_client/view/profile/profile_screen.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';

import '../../employee/employee_screen.dart';

class EmployeeListTile extends StatelessWidget {
  const EmployeeListTile({super.key, required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: ListTile(
          title: Text(
              "${employee.surname} ${employee.name} ${employee.patronymic ?? ""}"),
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => context
                                .read<ApplicationViewModel>()
                                .authorizedUser
                                ?.employee
                                .id ==
                            employee.id
                        ? const ProfileScreen()
                        : EmployeeScreen(
                            employee: employee,
                          )))
          },
        ),
      ),
    );
  }
}
