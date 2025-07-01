import 'package:ekod_alumni/src/features/authentication/application/auth_controller.dart';
import 'package:ekod_alumni/src/widgets/bouton-blanc.dart';
import 'package:ekod_alumni/src/widgets/input-password.dart';
import 'package:ekod_alumni/src/widgets/input.dart';
import 'package:ekod_alumni/src/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final List<String> _statuts = ['Étudiant', 'Alumni'];
  String? _selectedStatut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomTitle(text: 'Inscription'),
              const SizedBox(height: 16),
              InscriptionInput(
                controller: _nomController,
                label: 'Nom',
                hintText: 'Entrez votre nom',
              ),
              InscriptionInput(
                controller: _prenomController,
                label: 'Prénom',
                hintText: 'Entrez votre prénom',
              ),
              InscriptionInput(
                controller: _emailController,
                label: 'E-mail',
                hintText: 'Entrez votre e-mail',
              ),
              PasswordInput(
                label: 'Mot de passe',
                hintText: 'Entrez votre mot de passe',
                controller: _passwordController,
              ),
              Container(
                margin: const EdgeInsets.all(8),
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Vous êtes...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                  ),
                  hint: const Text('Vous êtes...'),
                  value: _selectedStatut,
                  items: _statuts.map((String statut) {
                    return DropdownMenuItem<String>(
                      value: statut,
                      child: Text(statut),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatut = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),
              WhiteButton(
                text: "S'inscrire",
                onPressed: () async {
                  final nom = _nomController.text.trim();
                  final prenom = _prenomController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;
                  final statut = _selectedStatut;

                  // Validation des champs
                  if (nom.isEmpty ||
                      prenom.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Veuillez remplir tous les champs obligatoires',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (statut == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez sélectionner votre statut'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    // Utiliser le controller pour l'inscription
                    await ref
                        .read(authControllerProvider.notifier)
                        .signUpWithEmailAndPassword(
                          email: email,
                          password: password,
                          firstName: prenom,
                          lastName: nom,
                          statut: statut,
                        );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Inscription réussie !'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.go('/sign-in');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Erreur lors de l'inscription: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
