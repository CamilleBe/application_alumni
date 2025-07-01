import 'package:ekod_alumni/src/features/authentication/data/auth_repository.dart';
import 'package:ekod_alumni/src/features/user/data/user_repository.dart';
import 'package:ekod_alumni/src/features/user/domain/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  /// Inscrit un nouvel utilisateur avec toutes ses informations
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? entreprise,
    String? statut,
  }) async {
    state = const AsyncValue.loading();

    try {
      final authRepository = _ref.read(authRepositoryProvider);
      final userRepository = _ref.read(userRepositoryProvider);

      // 1. Créer le compte Firebase Auth
      await authRepository.signUpWithEmailAndPassword(email, password);

      // 2. Récupérer l'utilisateur créé pour obtenir son UID
      final firebaseUser = authRepository.currentUser;
      if (firebaseUser == null) {
        throw Exception('Erreur lors de la création du compte');
      }

      // 3. Créer l'objet User avec toutes les informations
      final user = User(
        id: firebaseUser.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        entreprise: entreprise,
        statut: statut,
      );

      // 4. Sauvegarder les données utilisateur dans Firestore
      await userRepository.createUser(user);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Connecte un utilisateur existant
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final authRepository = _ref.read(authRepositoryProvider);
      await authRepository.signInWithEmailAndPassword(email, password);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Déconnecte l'utilisateur actuel
  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      final authRepository = _ref.read(authRepositoryProvider);
      await authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

// Provider pour le AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});
