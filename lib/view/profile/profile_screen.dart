import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/login_screen/login_screen.dart';
import 'package:restobook_mobile_client/view/profile/edit_password_screen.dart';
import 'package:restobook_mobile_client/view/shared_widget/floating_creation_reservation_button.dart';
import 'package:restobook_mobile_client/view/shared_widget/icon_button_navigator_pop.dart';
import 'package:restobook_mobile_client/view/shared_widget/scaffold_body_padding.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';

import '../shared_widget/info_label.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButtonNavigatorPop(),
        actions: [
          IconButton(
              onPressed: () {
                AppMetrica.reportEvent(const String.fromEnvironment("logout"));
                context.read<ApplicationViewModel>().logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              color: Theme.of(context).colorScheme.error,
              icon: const Icon(Icons.exit_to_app))
        ],
        title: Consumer<ApplicationViewModel>(
          builder: (context, applicationViewModel, child) {
            return Text(applicationViewModel.authorizedUser?.employee.shortFullName ?? "");
          },
        ),
      ),
      floatingActionButton: const FloatingCreationReservationButton(),
      body: ScaffoldBodyPadding(
        child: Consumer<ApplicationViewModel>(
          builder: (context, applicationViewModel, child) {
            return Column(
              children: [
                Row(
                  children: [
                    InfoLabel(label: "Имя:", info: applicationViewModel.authorizedUser?.employee.name ?? "")
                  ],
                ),
                Row(
                  children: [
                    InfoLabel(label: "Фамилия:", info: applicationViewModel.authorizedUser?.employee.surname ?? "")
                  ],
                ),
                Row(
                  children: [
                    InfoLabel(label: "Отчество:", info: applicationViewModel.authorizedUser?.employee.patronymic ?? "-")
                  ],
                ),
                Row(
                  children: [
                    InfoLabel(label: "Комментарий:", info: applicationViewModel.authorizedUser?.employee.comment ?? "-")
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                            MaterialPageRoute(builder: (context) => const EditPasswordScreen())
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.password),
                            Text("Изменить пароль"),
                          ],
                        ))
                  ],
                )
              ],
            );
          },
        ),
      )
    );
  }
}