import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/scaffold_body_padding.dart';
import 'package:restobook_mobile_client/view/shared_widget/scrollable_expanded.dart';
import 'package:restobook_mobile_client/view/table/screens/table_screen.dart';
import 'package:restobook_mobile_client/view/table/widgets/table_number_text_field.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';

import '../../../model/entities/table_model.dart';
import '../../../view_model/table_view_model.dart';
import '../../shared_widget/comment_text_field.dart';
import '../widgets/seats_number_text_field.dart';

class TableCreationScreen extends StatefulWidget {
  const TableCreationScreen({super.key});

  @override
  State<TableCreationScreen> createState() => _TableCreationScreenState();
}

class _TableCreationScreenState extends State<TableCreationScreen> {
  Future<void> submiting = Future.delayed(const Duration(seconds: 0));
  final _tableCreationFormKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _seatsNumberController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  bool _tableNumberUnique = true;

  @override
  void dispose() {
    _seatsNumberController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Новый стол")
      ),
      body: ScaffoldBodyPadding(
        child: ScrollableExpanded(
          child: Form(
            key: _tableCreationFormKey,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 25),
                    child: TableNumberTextField(
                        controller: _numberController,
                      errorText: _tableNumberUnique ? null : "Номер столика уже занят",
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: SeatsNumberTextField(controller: _seatsNumberController)
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: CommentTextField(controller: _commentController)
                ),
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
      )
    );
  }

  void submit() async {
    setState(() => _tableNumberUnique = true);
    if (_tableCreationFormKey.currentState!.validate()) {
      TableModel created = TableModel(
          null,
          int.parse(_numberController.text),
          int.parse(_seatsNumberController.text),
          "NORMAL",
          _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
          context.read<ApplicationViewModel>().authorizedUser?.employee.restaurantId,
          []);

      setState(() {
        int restaurantId = context
            .read<ApplicationViewModel>()
            .authorizedUser!
            .employee
            .restaurantId!;
        submiting = context
            .read<TableViewModel>()
            .add(restaurantId, created);
        submiting.then((value) async {
          AppMetrica.reportEvent(const String.fromEnvironment("create_table"));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TableScreen(table: context
                  .read<TableViewModel>()
                  .activeTable!)));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                  Text("Стол успешно добавлен")));
        });
        submiting.onError((error, stackTrace) {
          // setState(() => _tableNumberUnique = false);
          if (error is DioException) {
            final data = error.response?.data;
            if (data != null && data is Map<String, dynamic> && data.containsKey("messages")) {
              final messages = data["messages"] as List<dynamic>;
              for (var message in messages) {
                if (message.startsWith("Table number must be unique in restaurant")) {
                  setState(() => _tableNumberUnique = false);
                }
              }
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                  Text("Не удалось создать стол")));
        });
      });
    }
  }
}