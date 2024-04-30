import 'package:flutter/material.dart';

class AdministratorRegistrationInfoScreen extends StatelessWidget {
  const AdministratorRegistrationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Как зарегистрироваться"),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(25),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Для администратора",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                    const Row(
                      children: [
                        Flexible(
                            child: Text(
                                "Чтобы получить доступ к приложению, напишите заявку с темой \"Регистрация\" на почту pavelputin2003@yandex.ru")),
                      ],
                    ),
                    const Row(
                      children: [
                        Flexible(child: Text("В письме укажите:")),
                      ],
                    ),
                    const Row(
                      children: [
                        Flexible(child: Text("- Название ресторана")),
                      ],
                    ),
                    const Row(
                      children: [
                        Flexible(child: Text("- Полное имя юридического лица")),
                      ],
                    ),
                    const Row(
                      children: [
                        Flexible(child: Text("- ИНН")),
                      ],
                    ),
                    const Row(
                      children: [
                        Flexible(child: Text("- Ваше ФИО")),
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
