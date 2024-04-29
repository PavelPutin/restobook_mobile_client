import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_navigator_pop.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButtonNavigatorPop(),
        title: Consumer<ApplicationViewModel>(
          builder: (context, applicationViewModel, child) {
            return Text(applicationViewModel.authorizedUser!.employee.shortFullName);
          },
        ),
      ),
      body: Consumer<ApplicationViewModel>(
        builder: (context, applicationViewModel, child) {
          return Column(
            children: [
              Row(
                children: [
                  Text(
                      "Имя: ${applicationViewModel.authorizedUser!.employee.name}")
                ],
              ),
              Row(
                children: [
                  Text("Фамилия: ${applicationViewModel.authorizedUser!.employee.surname}")
                ],
              ),
              Row(
                children: [
                  Text("Отчество: ${applicationViewModel.authorizedUser!.employee.patronymic}")
                ],
              ),
              Row(
                children: [
                  Text("Комментарий: ${applicationViewModel.authorizedUser!.employee.comment}")
                ],
              )
            ],
          );
        },
      )
    );
  }
}