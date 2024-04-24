import 'package:flutter/material.dart';

import '../profile/profile_screen.dart';

class IconButtonPushProfile extends StatelessWidget {
  const IconButtonPushProfile({super.key});


  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen())
          )
        },
        icon: const Icon(Icons.person)
    );
  }
}