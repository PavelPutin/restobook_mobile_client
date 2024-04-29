import 'package:flutter/material.dart';

class EmployeeRegistrationInfoScreen extends StatelessWidget {
  const EmployeeRegistrationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Как зарегистрироваться"),
        ),
        body: Center(
          child: Card(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: const Column(
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
          ),
        ));
  }
}
