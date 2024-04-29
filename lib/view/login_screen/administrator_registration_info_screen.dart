import 'package:flutter/material.dart';

class AdministratorRegistrationInfoScreen extends StatelessWidget {
  const AdministratorRegistrationInfoScreen({super.key});

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
                  Text("Регистрация для администратора"),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                          "Чтобы получить доступ к приложению, напишите заявку с темой \"Регистрация\" на почту pavelputin2003@yandex.ru")),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                          "В письме укажите:")),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                          "- Название ресторана")),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                          "- Полное имя юридического лица")),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                          "- ИНН")),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                          "- Ваше ФИО")),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}