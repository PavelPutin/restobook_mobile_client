import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/scaffold_body_padding.dart';
import 'package:restobook_mobile_client/view_model/employee_view_model.dart';

import '../../model/entities/employee.dart';
import '../shared_widget/comment_text_field.dart';
import '../shared_widget/default_text_field.dart';
import '../shared_widget/scrollable_expanded.dart';
import '../shared_widget/title_future_builder.dart';
import 'employee_screen.dart';

class EmployeeEditScreen extends StatefulWidget {
  const EmployeeEditScreen({super.key, required this.employee});

  final Employee employee;

  @override
  State<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  late Future<void> loading;
  late Future<void> submiting;
  final _editEmployeeFormKey = GlobalKey<FormState>();

  final _surnameController = TextEditingController();
  final _nameController = TextEditingController();
  final _patronymicController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    submiting = Future.delayed(const Duration(seconds: 0));
    loading = Provider.of<EmployeeViewModel>(context, listen: false)
        .loadActiveEmployee(widget.employee.id!);
    loading.then((value) {
      String surname = Provider
          .of<EmployeeViewModel>(context, listen: false)
          .activeEmployee!
          .surname;
      _surnameController.value = TextEditingValue(text: surname);

      String name = Provider
          .of<EmployeeViewModel>(context, listen: false)
          .activeEmployee!
          .name;
      _nameController.value = TextEditingValue(text: name);

      String? patronymic = Provider
          .of<EmployeeViewModel>(context, listen: false)
          .activeEmployee!
          .patronymic;
      _patronymicController.value = TextEditingValue(text: patronymic ?? "");

      String? comment = Provider
          .of<EmployeeViewModel>(context, listen: false)
          .activeEmployee!
          .comment;
      _commentController.value = TextEditingValue(text: comment ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TitleFutureBuilder(
              loading: loading,
              errorMessage: const Text("Ошибка загрузки"),
              title: Consumer<EmployeeViewModel>(
                  builder: (context, employeeViewModel, child) {
                    return Text(
                        "Редактирование ${employeeViewModel.activeEmployee
                            ?.shortFullName}");
                  }))),
        body: ScaffoldBodyPadding(
          child: ScrollableExpanded(
            child: Form(
              key: _editEmployeeFormKey,
              child: Column(
                children: [
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
                            return const Text("Изменить");
                          }))
                ],
              ),
            ),
          ),
        )
    );
  }

  void submit() async {
    if (_editEmployeeFormKey.currentState!.validate()) {
      var source = context.read<EmployeeViewModel>().activeEmployee!;

      Employee updated = Employee(
          source.id,
          source.login,
          _surnameController.text,
          _nameController.text,
          _patronymicController.text.trim().isEmpty
              ? null
              : _patronymicController.text.trim(),
          _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
          source.changedPassword,
          source.restaurantId);

      setState(() {
        submiting = context.read<EmployeeViewModel>().update(updated);
        submiting.then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Сотрудник успешно изменён")));
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Не удалось изменить сотрудника")));
        });
      });
    }
  }
}
