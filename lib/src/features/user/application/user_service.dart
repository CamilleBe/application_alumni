import 'package:ekod_alumni/src/exceptions/exceptions.dart';
import 'package:ekod_alumni/src/features/authentication/authentication.dart';
import 'package:ekod_alumni/src/features/user/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_service.g.dart';

class UserService {
  UserService(this.ref);

  final Ref ref;

  AuthRepository get authRepository => ref.read(authRepositoryProvider);
  UserRepository get userRepository => ref.read(userRepositoryProvider);

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    await authRepository.signUpWithEmailAndPassword(email, password);

    final currentUser = authRepository.currentUser;
    if (currentUser == null) {
      throw UserNotSignedInException();
    }

    throw UnimplementedError();
  }
}

@Riverpod(keepAlive: true)
UserService userService(Ref ref) {
  return UserService(ref);
}

@riverpod
FutureOr<User?> userFuture(Ref ref) {
  final userId = ref.watch(authStateChangesProvider).value?.uid;
  if (userId != null) {
    return ref.watch(userRepositoryProvider).fetchUser(userId);
  } else {
    return null;
  }
}

@riverpod
Stream<User?> userStream(Ref ref) {
  final userId = ref.watch(authStateChangesProvider).value?.uid;
  if (userId != null) {
    return ref.watch(userRepositoryProvider).watchUser(userId);
  } else {
    return Stream.value(null);
  }
}
