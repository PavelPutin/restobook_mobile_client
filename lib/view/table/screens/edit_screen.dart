import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/view/table/widgets/scrollable_expanded_future_builder.dart';
import '../../../view_model/application_view_model.dart';
import '../../../view_model/table_view_model.dart';
import '../../shared_widget/scaffold_body_padding.dart';
import '../../shared_widget/title_future_builder.dart';
import '../../shared_widget/comment_text_field.dart';
import '../widgets/seats_number_text_field.dart';
import '../widgets/table_state_dropdown_menu.dart';

class TableEditScreen extends StatefulWidget {
  const TableEditScreen({super.key, required this.table});

  final TableModel table;

  @override
  State<TableEditScreen> createState() => _TableEditScreenState();
}

class _TableEditScreenState extends State<TableEditScreen> {
  late Future<void> loading;
  late Future<void> submiting;
  final _formKey = GlobalKey<FormState>();
  String _selectedTableState = "NORMAL";
  final TextEditingController _seatsNumberController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    submiting = Future.delayed(const Duration(seconds: 0));
    int restaurantId = Provider.of<ApplicationViewModel>(context, listen: false)
        .authorizedUser!
        .employee
        .restaurantId!;
    loading = Provider.of<TableViewModel>(context, listen: false)
        .loadActiveTable(restaurantId, widget.table.id!);
    loading.then((value) {
      setState(() {
        _selectedTableState = Provider.of<TableViewModel>(context, listen: false)
            .activeTable!
            .state!;
      });

      String seatsNumber = Provider.of<TableViewModel>(context, listen: false)
          .activeTable!
          .seatsNumber
          .toString();
      _seatsNumberController.value = TextEditingValue(text: seatsNumber);

      String? comment = Provider.of<TableViewModel>(context, listen: false)
          .activeTable!
          .comment;
      _commentController.value = TextEditingValue(text: comment ?? "");
    });
  }

  @override
  void dispose() {
    _seatsNumberController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent(const String.fromEnvironment("edit_table"));
    return Scaffold(
        appBar: AppBar(
            title: TitleFutureBuilder(
                loading: loading,
                errorMessage: const Text("Ошибка загрузки"),
                title: Consumer<TableViewModel>(
                    builder: (context, tableViewModel, child) {
                  return Text("Стол ${tableViewModel.activeTable?.number}");
                }))),
        body: ScaffoldBodyPadding(
          child: ScrollableExpandedFutureBuilder(
              loading: loading,
              onRefresh: () async {
                int restaurantId = context
                    .read<ApplicationViewModel>()
                    .authorizedUser!
                    .employee
                    .restaurantId!;
                setState(() => loading = context
                  .read<TableViewModel>()
                  .loadActiveTable(restaurantId, widget.table.id!));
                },
              errorLabel: const Text("Не удалось загрузить стол"),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: SeatsNumberTextField(controller: _seatsNumberController)
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: CommentTextField(controller: _commentController)
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TableStateDropdownMenu(
                          initialValue: _selectedTableState,
                          onChanged: (selected) => setState(() {
                            _selectedTableState = selected;
                          }),
                        ),
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
                                return const Text("Применить");
                              }))
                    ],
                  )
              )
          ),
        )
    );
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      TableModel updated = TableModel(
          context.read<TableViewModel>().activeTable!.id,
          context
              .read<TableViewModel>()
              .activeTable!
              .number,
          int.parse(_seatsNumberController.text),
          _selectedTableState,
          _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
          context
              .read<TableViewModel>()
              .activeTable!
              .restaurantId,
          context
              .read<TableViewModel>()
              .activeTable!
              .reservationIds);

      setState(() {
        submiting = context
            .read<TableViewModel>()
            .update(updated);
        submiting.then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                  Text("Стол успешно обновлён")));
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                  Text("Не удалось изменить стол")));
        });
      });
    }
  }
}
