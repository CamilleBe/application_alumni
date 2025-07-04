import 'package:ekod_alumni/src/widgets/btn-rouge.dart';
import 'package:ekod_alumni/src/widgets/input-password.dart';
import 'package:ekod_alumni/src/widgets/input.dart';
import 'package:ekod_alumni/src/widgets/text.dart';
import 'package:ekod_alumni/src/widgets/title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  //final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomTitle(
                text: 'Connexion',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              InscriptionInput(
                controller: _emailController,
                label: 'E-mail',
                hintText: 'Entrez votre e-mail',
              ),
              PasswordInput(
                controller: _passwordController,
                label: 'Mot de passe',
                hintText: 'Entrez votre mot de passe',
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  const CustomText(
                    text: 'Pas encore inscrit ?',
                    fontSize: 14,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      context.go('/sign-up');
                    },
                    child: const Text(
                      'Faites-le dès maintenant',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              RedButton(
                text: _isLoading ? 'Connexion en cours...' : 'Se connecter',
                onPressed: _isLoading ? null : _handleLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        context.go('/');
      }
    } on FirebaseAuthException catch (e) {
      var message = 'Une erreur est survenue';

      switch (e.code) {
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Mail ou mot de passe invalide';
        default:
          message = 'Une erreur est survenue';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
