import 'package:flutter/material.dart';

class EmployeeRegistrationInfoScreen extends StatelessWidget {
  const EmployeeRegistrationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Как зарегистрироваться"),
        ),
        body: const Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Регистрация для сотрудника"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                            "Чтобы получить доступ к приложению, обратитесь к администратору вашего ресторана. Он выдаст вам логин и пароль для входа")),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
