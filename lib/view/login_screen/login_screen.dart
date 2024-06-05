import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/login_screen/administrator_registration_info_screen.dart';
import 'package:restobook_mobile_client/view/login_screen/employee_registration_info_screen.dart';
import 'package:restobook_mobile_client/view/main_screen/main_screen.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';

import '../shared_widget/default_text_field.dart';
import '../shared_widget/password_textfield.dart';
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

  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent(const String.fromEnvironment("open_login_page"));
    return Scaffold(
        body: ScaffoldBodyPadding(
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Вход",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: DefaultTextField(
                          controller: _loginController,
                          labelText: "Логин",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Поле обязательное";
                            }
                            if (value.length > 512) {
                              return "Логин не должен быть длиннее 512 символов";
                            }
                            return null;
                          },
                          onChange: (value) {
                            if (value != null) {
                              _loginController.value =
                                  TextEditingValue(text: value.toLowerCase());
                            }
                          },
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: PasswordTextField(
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Поле обязательное";
                                }
                                return null;
                              }))
                    ],
                  ),
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Как получить учётную запись?")],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AdministratorRegistrationInfoScreen()));
                        },
                        child: const Text("Я администратор")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EmployeeRegistrationInfoScreen()));
                        },
                        child: const Text("Я сотрудник"))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton(
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
      ),
    ));
  }

  void submit() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        submiting = context
            .read<ApplicationViewModel>()
            .login(_loginController.text, _passwordController.text);
        submiting.then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Добро пожаловать")));
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Не удалось войти. Неверный логин или пароль")));
        });
      });
    }
  }
}
