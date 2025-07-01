import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ekod_alumni/src/widgets/bouton-blanc.dart';
import 'package:ekod_alumni/src/widgets/btn-rouge.dart';
import 'package:ekod_alumni/src/widgets/logo-ekod.dart';
import 'package:ekod_alumni/src/widgets/text.dart';
import 'package:ekod_alumni/src/widgets/title.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoWidget(),
              const SizedBox(height: 32),
              const CustomTitle(
                text: "Bienvenue sur l'application EKOD alumni",
              ),
              const SizedBox(height: 15),
              const CustomText(
                text:
                    'Vous pouvez vous connectez avec votre compte EKOD ou en créer un',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              RedButton(
                text: 'Se connecter',
                onPressed: () {
                  context.go('/sign-in');
                },
              ),
              const SizedBox(height: 12),
              WhiteButton(
                text: "S'inscrire",
                onPressed: () {
                  context.go('/sign-up');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
