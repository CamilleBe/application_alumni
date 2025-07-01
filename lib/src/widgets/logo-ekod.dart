import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        'assets/images/logo.png', // Assurez-vous que le chemin correspond à votre structure
        width: 200, // Vous pouvez ajuster la taille selon vos besoins
        fit: BoxFit.contain,
      ),
    );
  }
}
