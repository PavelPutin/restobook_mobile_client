import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

class DeleteAlertDialog extends StatefulWidget {
  const DeleteAlertDialog({super.key, required this.title});

  final Widget title;

  @override
  State<DeleteAlertDialog> createState() => _DeleteAlertDialogState();
}

class _DeleteAlertDialogState extends State<DeleteAlertDialog> {
  Future<void> deleting = Future.delayed(const Duration(seconds: 0));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_forever),
      title: widget.title,
      content: const Text("Внимание! Это действие нельзя отменить"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Отмена")),
        TextButton(
            onPressed: () async {
              var promise = context
                  .read<TableViewModel>()
                  .delete(context.read<TableViewModel>().activeTable!);
              setState(() {
                deleting = promise;
              });
              await promise.then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Стол удалён")));
              }).onError((error, stackTrace) {
                print(error);
                print(stackTrace);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Не удалось удалить стол")));
              });
            },
            child: FutureBuilder(
              future: deleting,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return const Text("Удалить");
              },
            )),
      ],
    );
  }
}
