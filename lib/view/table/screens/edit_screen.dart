import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../../../view_model/table_view_model.dart';
import '../../shared_widget/title_future_builder.dart';

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
  String? _selectedTableState = "NORMAL";
  late TextEditingController _seatsNumberController;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    submiting = Future.delayed(const Duration(seconds: 0));
    loading = Provider.of<TableViewModel>(context, listen: false)
        .loadActiveTable(widget.table.id!);
    loading.then((value) {
      String seatsNumber = Provider.of<TableViewModel>(context, listen: false)
          .activeTable!
          .seatsNumber
          .toString();
      _seatsNumberController = TextEditingController(text: seatsNumber);

      String? comment = Provider.of<TableViewModel>(context, listen: false)
          .activeTable!
          .comment;
      _commentController = comment != null
          ? TextEditingController(text: comment)
          : TextEditingController();
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
    return Scaffold(
        appBar: AppBar(
            title: TitleFutureBuilder(
                loading: loading,
                errorMessage: const Text("Ошибка загрузки"),
                title: Consumer<TableViewModel>(
                    builder: (context, tableViewModel, child) {
                  return Text("Стол ${tableViewModel.activeTable?.number}");
                }))),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: FutureBuilder(
                            future: loading,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                                          
                              if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Не удалось загрузить стол"),
                                      ElevatedButton(
                                          onPressed: () async => setState(() => loading =
                                              context
                                                  .read<TableViewModel>()
                                                  .loadActiveTable(widget.table.id!)),
                                          child: const Text("Попробовать ещё раз"))
                                    ],
                                  ),
                                );
                              }
                                          
                              return Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                          controller: _seatsNumberController,
                                          keyboardType: TextInputType.number,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Количество мест"),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ]),
                                      TextFormField(
                                          controller: _commentController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Комментарий")),
                                      DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Состояние"),
                                        items: const [
                                          DropdownMenuItem<String>(
                                              value: "NORMAL", child: Text("Нормальный")),
                                          DropdownMenuItem<String>(
                                              value: "BROKEN", child: Text("Сломаный"))
                                        ],
                                        onChanged: (String? selected) {
                                          if (selected is String) {
                                            setState(() {
                                              _selectedTableState = selected;
                                            });
                                          }
                                        },
                                        value: _selectedTableState,
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              // processing data code
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                      content: Text("Изменяем стол")));
                                              TableModel updated = TableModel(
                                                  context
                                                      .read<TableViewModel>()
                                                      .activeTable!
                                                      .id,
                                                  context
                                                      .read<TableViewModel>()
                                                      .activeTable!
                                                      .number,
                                                  context
                                                      .read<TableViewModel>()
                                                      .activeTable!
                                                      .seatsNumber,
                                                  context
                                                      .read<TableViewModel>()
                                                      .activeTable!
                                                      .state,
                                                  context
                                                      .read<TableViewModel>()
                                                      .activeTable!
                                                      .comment,
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
                                              });
                                            }
                                          },
                                          child: const Text("Применить"))
                                    ],
                                  ));
                            }),
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }
}
