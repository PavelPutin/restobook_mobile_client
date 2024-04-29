import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/application_view_model.dart';

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
  var _oldPasswordVisible = false;
  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Изменить пароль"),
        ),
        body: Form(
          key: _passwordEditingFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: !_oldPasswordVisible,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(_oldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _oldPasswordVisible = !_oldPasswordVisible;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "Старый пароль"),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "Новый пароль"),
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
                        return const Text("Войти");
                      })),
            ],
          ),
        ),
    );
  }

  void submit() async {
    if (_passwordEditingFormKey.currentState!.validate()) {
      setState(() {
        submiting = context.read<ApplicationViewModel>().changePassword(_oldPasswordController.text, _passwordController.text);
        submiting.then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Пароль изменён")));
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Не удалось изменить пароль")));
        });
      });
    }
  }
}
