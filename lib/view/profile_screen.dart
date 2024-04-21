import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/view/widgets/icon_button_navigtor_pop.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButtonNavigatorPop(),
        title: const Text("Имя сотрудника"),
      ),
      body: const Center(
        child: Text("Profile"),
      ),
    );
  }
}