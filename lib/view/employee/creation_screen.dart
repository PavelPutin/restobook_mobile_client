import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/view/employee/employee_screen.dart';
import 'package:restobook_mobile_client/view/shared_widget/comment_text_field.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';

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
                  DefaultTextField(
                      controller: _loginController,
                      labelText: "Логин сотрудника"),
                  PasswordTextField(controller: _passwordController),
                  DefaultTextField(
                      controller: _surnameController,
                      labelText: "Фамилия сотрудника"),
                  DefaultTextField(
                      controller: _nameController, labelText: "Имя сотрудника"),
                  DefaultTextField(
                      controller: _patronymicController,
                      labelText: "Отчество сотрудника"),
                  CommentTextField(controller: _commentController),
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
          1);

      setState(() {
        submiting = context.read<EmployeeViewModel>().add(updated);
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
