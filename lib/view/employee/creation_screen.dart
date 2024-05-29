import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/view/employee/employee_screen.dart';
import 'package:restobook_mobile_client/view/shared_widget/comment_text_field.dart';


import '../../view_model/application_view_model.dart';
import '../../view_model/employee_view_model.dart';
import '../shared_widget/default_text_field.dart';
import '../shared_widget/password_textfield.dart';
import '../shared_widget/scaffold_body_padding.dart';
import '../shared_widget/scrollable_expanded.dart';

class EmployeeCreationScreen extends StatefulWidget {
  const EmployeeCreationScreen({super.key});

  @override
  State<EmployeeCreationScreen> createState() => _EmployeeCreationScreenState();
}

class _EmployeeCreationScreenState extends State<EmployeeCreationScreen> {
  final _employeeCreationFormKey = GlobalKey<FormState>();
  Future<void> submiting = Future.delayed(const Duration(seconds: 0));
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _surnameController = TextEditingController();
  final _nameController = TextEditingController();
  final _patronymicController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent(const String.fromEnvironment("create_employee"));
    return Scaffold(
        appBar: AppBar(
          title: const Text("Новый сотрудник"),
        ),
        body: ScaffoldBodyPadding(
          child: ScrollableExpanded(
            child: Form(
              key: _employeeCreationFormKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: DefaultTextField(
                        controller: _loginController,
                        labelText: "Логин сотрудника",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Поле обязательное";
                          }
                          if (value.length > 512) {
                            return "Логин не должен быть длиннее 512 символов";
                          }
                          return null;
                        }),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: PasswordTextField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Поле обязательное";
                            }
                            return null;
                          })),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: DefaultTextField(
                        controller: _surnameController,
                        labelText: "Фамилия сотрудника",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Поле обязательное";
                          }
                          if (value.length > 512) {
                            return "Фамилия не должна быть длиннее 512 символов";
                          }
                          return null;
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: DefaultTextField(
                        controller: _nameController,
                        labelText: "Имя сотрудника",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Поле обязательное";
                          }
                          if (value.length > 512) {
                            return "Имя не должно быть длиннее 512 символов";
                          }
                          return null;
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: DefaultTextField(
                        controller: _patronymicController,
                        labelText: "Отчество сотрудника",
                        validator: (value) {
                          if (value != null && value.length > 512) {
                            return "Отчество не должно быть длиннее 512 символов";
                          }
                          return null;
                        }),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: CommentTextField(controller: _commentController)),
                  ElevatedButton(
                      onPressed: submit,
                      child: FutureBuilder(
                          future: submiting,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            return const Text("Создать");
                          }))
                ],
              ),
            ),
          ),
        ));
  }

  void submit() async {
    if (_employeeCreationFormKey.currentState!.validate()) {
      String password = _passwordController.text;
      Employee updated = Employee(
          null,
          _loginController.text,
          _surnameController.text,
          _nameController.text,
          _patronymicController.text.trim().isEmpty
              ? null
              : _patronymicController.text.trim(),
          _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
          false,
          context.read<ApplicationViewModel>().authorizedUser?.employee.restaurantId);

      setState(() {
        int restaurantId = context.read<ApplicationViewModel>().authorizedUser!.employee.restaurantId!;
        submiting = context.read<EmployeeViewModel>().add(restaurantId, updated, password);
        submiting.then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeeScreen(
                      employee:
                          context.read<EmployeeViewModel>().activeEmployee!)));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Сотрудник успешно добавлен")));
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Не удалось создать сотрудника")));
        });
      });
    }
  }
}
