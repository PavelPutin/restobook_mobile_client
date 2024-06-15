import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/scaffold_body_padding.dart';

import '../../view_model/application_view_model.dart';
import '../shared_widget/password_textfield.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _passwordEditingFormKey = GlobalKey<FormState>();
  Future<void> submiting = Future.delayed(const Duration(seconds: 0));
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _oldPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent(const String.fromEnvironment("open_edit_password_screen"));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Изменить пароль"),
      ),
      body: ScaffoldBodyPadding(
        child: Form(
          key: _passwordEditingFormKey,
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 25),
                  child: PasswordTextField(
                      controller: _oldPasswordController,
                      labelText: "Старый пароль",
                      errorText: _oldPasswordValid ? null : "Неправильный пароль",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Поле обязательное";
                        }
                        return null;
                      })),
              Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: PasswordTextField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Поле обязательное";
                      }
                      return null;
                    }
                  )),
              ElevatedButton(
                  onPressed: submit,
                  child: FutureBuilder(
                      future: submiting,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return const Text("Изменить");
                      })),
            ],
          ),
        ),
      ),
    );
  }

  void submit() async {
    if (_passwordEditingFormKey.currentState!.validate()) {
      setState(() {
        _oldPasswordValid = true;
        submiting = context.read<ApplicationViewModel>().changePassword(
            _oldPasswordController.text, _passwordController.text);
        submiting.then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Пароль изменён")));
        });
        submiting.onError((error, stackTrace) {
          if (error == "Invalid old password") {
            setState(() => _oldPasswordValid = false);
          }

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Не удалось изменить пароль")));
        });
      });
    }
  }
}
