import 'package:ekod_alumni/src/features/authentication/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _hasCurrentPasswordError = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Changer le mot de passe'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      size: 32,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sécurité de votre compte',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Pour changer votre mot de passe, vous devez d'abord confirmer votre mot de passe actuel.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Formulaire
              _buildPasswordField(
                controller: _currentPasswordController,
                label: 'Mot de passe actuel',
                hint: 'Entrez votre mot de passe actuel',
                icon: Icons.lock_outline,
                hasError: _hasCurrentPasswordError,
                onChanged: (_) {
                  if (_hasCurrentPasswordError) {
                    setState(() {
                      _hasCurrentPasswordError = false;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              _buildPasswordField(
                controller: _newPasswordController,
                label: 'Nouveau mot de passe',
                hint: 'Entrez votre nouveau mot de passe',
                icon: Icons.lock,
                helperText: 'Au moins 6 caractères',
              ),

              const SizedBox(height: 20),

              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Confirmer le nouveau mot de passe',
                hint: 'Confirmez votre nouveau mot de passe',
                icon: Icons.lock_clock,
              ),

              const SizedBox(height: 40),

              // Bouton de changement
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => _handleChangePassword(authRepository),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Changement en cours...'),
                        ],
                      )
                    : const Text(
                        'Changer le mot de passe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // Bouton d'annulation
              OutlinedButton(
                onPressed: _isLoading ? null : () => context.go('/profile'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? helperText,
    bool hasError = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: hasError ? Colors.red[700] : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: true,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: hasError ? Colors.red[600] : Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey[300]!,
                width: hasError ? 2 : 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey[300]!,
                width: hasError ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.red,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor:
                hasError ? Colors.red.withValues(alpha: 0.05) : Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            helperText: helperText,
            helperStyle: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Future<void> _handleChangePassword(AuthRepository authRepository) async {
    // Réinitialiser les erreurs visuelles
    setState(() {
      _hasCurrentPasswordError = false;
    });

    // Validation des mots de passe
    if (_currentPasswordController.text.trim().isEmpty) {
      _showErrorSnackBar('Veuillez entrer votre mot de passe actuel');
      return;
    }

    if (_newPasswordController.text.trim().isEmpty) {
      _showErrorSnackBar('Veuillez entrer un nouveau mot de passe');
      return;
    }

    if (_confirmPasswordController.text.trim().isEmpty) {
      _showErrorSnackBar('Veuillez confirmer votre nouveau mot de passe');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Les mots de passe ne correspondent pas');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      _showErrorSnackBar('Le mot de passe doit contenir au moins 6 caractères');
      return;
    }

    if (_currentPasswordController.text == _newPasswordController.text) {
      _showErrorSnackBar(
        "Le nouveau mot de passe doit être différent de l'actuel",
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await authRepository.changePassword(
        _currentPasswordController.text.trim(),
        _newPasswordController.text.trim(),
      );

      if (context.mounted) {
        // Afficher un message de succès
        _showSuccessSnackBar('Mot de passe changé avec succès !');

        // Retourner au profil après un délai pour que l'utilisateur voie le message
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            context.go('/profile');
          }
        });
      }
    } catch (e) {
      _handlePasswordChangeError(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handlePasswordChangeError(dynamic error) {
    String userFriendlyMessage;
    var errorString = error.toString();

    // Nettoyer le message d'erreur (enlever "Exception: " au début)
    if (errorString.startsWith('Exception: ')) {
      errorString = errorString.substring(11);
    }

    // Mapper les erreurs à des messages conviviaux
    if (errorString.contains('Mot de passe actuel incorrect') ||
        errorString.contains('wrong-password') ||
        errorString.contains('invalid-credential')) {
      userFriendlyMessage =
          'Le mot de passe actuel que vous avez saisi est incorrect. Veuillez vérifier et réessayer.';
      // Marquer visuellement le champ de mot de passe actuel comme ayant une erreur
      setState(() {
        _hasCurrentPasswordError = true;
      });
    } else if (errorString.contains('weak-password') ||
        errorString.contains('trop faible')) {
      userFriendlyMessage =
          'Le nouveau mot de passe est trop faible. Utilisez au moins 6 caractères avec des lettres et des chiffres.';
    } else if (errorString.contains('requires-recent-login') ||
        errorString.contains('reconnecter')) {
      userFriendlyMessage =
          'Veuillez vous reconnecter avant de changer votre mot de passe';
    } else if (errorString.contains('too-many-requests') ||
        errorString.contains('Trop de tentatives')) {
      userFriendlyMessage =
          'Trop de tentatives de changement de mot de passe. Veuillez réessayer dans quelques minutes.';
    } else if (errorString.contains('network-request-failed') ||
        errorString.contains('réseau') ||
        errorString.contains('connexion')) {
      userFriendlyMessage =
          'Problème de connexion internet. Vérifiez votre connexion et réessayez.';
    } else if (errorString.contains('user-disabled')) {
      userFriendlyMessage =
          'Votre compte a été temporairement désactivé. Contactez le support.';
    } else if (errorString.contains('user-not-found')) {
      userFriendlyMessage =
          'Compte utilisateur introuvable. Veuillez vous reconnecter.';
    } else {
      // Si l'erreur est déjà conviviale (du repository), l'utiliser
      if (errorString.contains('Mot de passe') ||
          errorString.contains('Email') ||
          errorString.contains('Utilisateur') ||
          errorString.contains('compte')) {
        userFriendlyMessage = errorString;
      } else {
        // Message générique pour les erreurs non mappées
        userFriendlyMessage =
            'Une erreur est survenue lors du changement de mot de passe. Veuillez réessayer.';
      }
    }

    _showErrorSnackBar(userFriendlyMessage);
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
