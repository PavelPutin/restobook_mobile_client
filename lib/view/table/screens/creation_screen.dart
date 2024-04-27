import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/number_text_field.dart';
import 'package:restobook_mobile_client/view/shared_widget/scrollable_expanded.dart';
import 'package:restobook_mobile_client/view/table/screens/table_screen.dart';
import 'package:restobook_mobile_client/view/table/widgets/table_number_text_field.dart';

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
      body: ScrollableExpanded(
        child: Form(
          key: _tableCreationFormKey,
          child: Column(
            children: [
              TableNumberTextField(controller: _numberController),
              SeatsNumberTextField(controller: _seatsNumberController),
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
      )
    );
  }

  void submit() async {
    if (_tableCreationFormKey.currentState!.validate()) {
      TableModel updated = TableModel(
          null,
          int.parse(_numberController.text),
          int.parse(_seatsNumberController.text),
          "NORMAL",
          _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
          null,
          null);

      setState(() {
        submiting = context
            .read<TableViewModel>()
            .add(updated);
        submiting.then((value) {
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
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                  Text("Не удалось создать стол")));
        });
      });
    }
  }
}