import 'dart:async';

import 'package:ekod_alumni/src/features/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_token_refresh_service.g.dart';

/// Class used to force an ID token refresh on sign in.
class UserTokenRefreshService {
  UserTokenRefreshService(this.ref) {
    _init();
  }

  final Ref ref;

  StreamSubscription<DateTime?>? _subscription;

  void _init() {
    ref.listen<AsyncValue<User?>>(authStateChangesProvider, (previous, next) {
      final user = next.value;
      // * If a previous subscription was active, dispose it
      _subscription?.cancel();
      if (user != null) {
        // * On sign-in, listen to user metadata updates
        // * (and register a subscription)
        _subscription = ref
            .read(userMetadataRepositoryProvider)
            .watchUserMetadata(user.uid)
            .listen((refreshTime) async {
          // * Read user again as it may be null by the time we reach
          // * this callback
          final user = ref.read(authRepositoryProvider).currentUser;
          if (refreshTime != null && user != null) {
            // * Force an ID token refresh, which will cause a new stream event
            // * to be emitted by [idTokenChanges]
            final token = await user.getIdToken(true);
            debugPrint(
              'Force refresh token: $refreshTime, '
              'uid:${user.uid}, '
              'token: $token',
            );
          }
        });
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}

@Riverpod(keepAlive: true)
UserTokenRefreshService userTokenRefreshService(Ref ref) {
  final service = UserTokenRefreshService(ref);
  ref.onDispose(service.dispose);
  return service;
}
