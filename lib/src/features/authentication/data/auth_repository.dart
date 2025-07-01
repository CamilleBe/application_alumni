import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

/// {@template auth_repository}
/// Provides an interface to interact with the Firebase Authentication API.
/// {@endtemplate}
class AuthRepository {
  /// {@macro auth_repository}
  AuthRepository({
    required FirebaseAuth auth,
  }) : _auth = auth;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  /// Notifies about changes to the user's sign-in state (such as sign-in or
  /// sign-out).
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Tries to create a new user account with the given email address and
  /// password.
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception(
              'Le mot de passe est trop faible. Utilisez au moins 6 caractères avec des lettres et des chiffres');
        case 'email-already-in-use':
          throw Exception(
              'Cet email est déjà utilisé. Essayez de vous connecter ou utilisez un autre email');
        case 'invalid-email':
          throw Exception('Email invalide');
        case 'operation-not-allowed':
          throw Exception(
              "L'inscription n'est pas autorisée. Contactez le support");
        case 'network-request-failed':
          throw Exception('Erreur réseau. Vérifiez votre connexion internet');
        case 'too-many-requests':
          throw Exception('Trop de tentatives. Veuillez réessayer plus tard');
        default:
          print(
              "Code d'erreur Firebase non géré dans signUp: ${e.code} - ${e.message}");
          throw Exception("Erreur lors de l'inscription. Veuillez réessayer");
      }
    } catch (e) {
      print('Erreur non-Firebase lors de signUp: $e');
      throw Exception("Erreur lors de l'inscription. Veuillez réessayer");
    }
  }

  /// Attempts to sign in a user with the given email address and password.
  ///
  /// If successful, it also signs the user in into the app and updates
  /// [authStateChanges] stream listener.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          throw Exception('Email ou mot de passe incorrect');
        case 'user-not-found':
          throw Exception('Aucun compte trouvé avec cet email');
        case 'user-disabled':
          throw Exception('Ce compte a été désactivé');
        case 'invalid-email':
          throw Exception('Email invalide');
        case 'too-many-requests':
          throw Exception('Trop de tentatives. Veuillez réessayer plus tard');
        case 'network-request-failed':
          throw Exception('Erreur réseau. Vérifiez votre connexion internet');
        case 'operation-not-allowed':
          throw Exception('Opération non autorisée');
        default:
          print(
            "Code d'erreur Firebase non géré dans signIn: ${e.code} - ${e.message}",
          );
          throw Exception('Erreur de connexion. Vérifiez vos identifiants');
      }
    } catch (e) {
      print('Erreur non-Firebase lors de signIn: $e');
      throw Exception('Erreur de connexion. Veuillez réessayer');
    }
  }

  /// Signs out the current user.
  ///
  /// If successful, it also updates [authStateChanges] stream listener.
  Future<void> signOut() {
    return _auth.signOut();
  }

  /// Re-authenticates the current user with their email and password.
  ///
  /// This is required before sensitive operations like changing password.
  Future<void> reauthenticateWithEmailAndPassword(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('Aucun utilisateur connecté');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          throw Exception('Mot de passe actuel incorrect');
        case 'invalid-email':
          throw Exception('Email invalide');
        case 'user-disabled':
          throw Exception('Ce compte a été désactivé');
        case 'user-not-found':
          throw Exception('Utilisateur non trouvé');
        case 'too-many-requests':
          throw Exception('Trop de tentatives. Veuillez réessayer plus tard');
        case 'network-request-failed':
          throw Exception('Erreur réseau. Vérifiez votre connexion internet');
        case 'operation-not-allowed':
          throw Exception('Opération non autorisée. Contactez le support');
        case 'invalid-argument':
          throw Exception('Paramètres invalides');
        case 'requires-recent-login':
          throw Exception('Veuillez vous reconnecter et réessayer');
        case 'credential-already-in-use':
          throw Exception('Ces identifiants sont déjà utilisés');
        case 'invalid-verification-code':
          throw Exception('Code de vérification invalide');
        case 'invalid-verification-id':
          throw Exception('Identifiant de vérification invalide');
        case 'missing-verification-code':
          throw Exception('Code de vérification manquant');
        case 'missing-verification-id':
          throw Exception('Identifiant de vérification manquant');
        case 'session-cookie-expired':
          throw Exception('Session expirée. Veuillez vous reconnecter');
        case 'uid-already-exists':
          throw Exception('Cet utilisateur existe déjà');
        case 'unauthorized-continue-uri':
          throw Exception('URL de redirection non autorisée');
        case 'user-token-expired':
          throw Exception('Token expiré. Veuillez vous reconnecter');
        case 'web-storage-unsupported':
          throw Exception('Stockage web non supporté par ce navigateur');
        default:
          // Log l'erreur pour debug mais affiche un message convivial
          print("Code d'erreur Firebase non géré: ${e.code} - ${e.message}");
          throw Exception('Mot de passe actuel incorrect');
      }
    } catch (e) {
      print('Erreur non-Firebase lors de la ré-authentification: $e');
      throw Exception(
        'Erreur lors de la vérification du mot de passe. Veuillez réessayer',
      );
    }
  }

  /// Updates the password for the current user.
  ///
  /// Requires recent authentication. Call [reauthenticateWithEmailAndPassword] first.
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Aucun utilisateur connecté');
    }

    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception(
            'Le nouveau mot de passe est trop faible. Utilisez au moins 6 caractères avec des lettres et des chiffres',
          );
        case 'requires-recent-login':
          throw Exception(
            'Veuillez vous reconnecter avant de changer votre mot de passe',
          );
        case 'operation-not-allowed':
          throw Exception('Opération non autorisée. Contactez le support');
        case 'invalid-user-token':
        case 'user-token-expired':
          throw Exception('Session expirée. Veuillez vous reconnecter');
        case 'network-request-failed':
          throw Exception('Erreur réseau. Vérifiez votre connexion internet');
        default:
          print(
            "Code d'erreur Firebase non géré dans updatePassword: ${e.code} - ${e.message}",
          );
          throw Exception(
            'Erreur lors du changement de mot de passe. Veuillez réessayer',
          );
      }
    } catch (e) {
      print('Erreur non-Firebase lors de updatePassword: $e');
      throw Exception(
        'Erreur lors du changement de mot de passe. Veuillez réessayer',
      );
    }
  }

  /// Changes the password for the current user.
  ///
  /// This method handles re-authentication and password update in one call.
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await reauthenticateWithEmailAndPassword(currentPassword);
      await updatePassword(newPassword);
    } catch (e) {
      // Rethrow the exception with the original message
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(auth: FirebaseAuth.instance);
}

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
