import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/employee/edit_screen.dart';
import 'package:restobook_mobile_client/view/login_screen/administrator_registration_info_screen.dart';
import 'package:restobook_mobile_client/view/login_screen/employee_registration_info_screen.dart';
import 'package:restobook_mobile_client/view/main_screen/main_screen.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';

import '../shared_widget/default_text_field.dart';
import '../shared_widget/scaffold_body_padding.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  Future<void> submiting = Future.delayed(const Duration(seconds: 0));
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaffoldBodyPadding(
        child: Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Вход"),
                  ],
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      DefaultTextField(
                          controller: _loginController,
                          labelText: "Логин"),
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
                            labelText: "Пароль"),
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("У меня нет аккаунта")
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdministratorRegistrationInfoScreen())
                          );
                        },
                        child: const Text("Я администратор")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EmployeeRegistrationInfoScreen())
                          );
                        },
                        child: const Text("Я сотрудник"))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  void submit() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        submiting = context.read<ApplicationViewModel>().login(_loginController.text, _passwordController.text);
        submiting.then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainScreen()));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Добро пожаловать")));
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Не удалось войти. Неверный логин или пароль")));
        });
      });
    }
  }
}