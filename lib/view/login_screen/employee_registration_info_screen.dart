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
          child: Container(
            margin: const EdgeInsets.all(25),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Для сотрудника",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                    const Row(
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
          ),
        ));
  }
}
