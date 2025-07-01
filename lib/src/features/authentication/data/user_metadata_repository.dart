import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_repository.g.dart';

/// Helper repository class to watch the user medatata in Firestore.
class UserMetadataRepository {
  const UserMetadataRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<DateTime?> watchUserMetadata(String uid) {
    final ref = _firestore.doc('metadata/$uid');
    return ref.snapshots().map((snapshot) {
      final data = snapshot.data();
      final refreshTime = data?['refreshTime'];
      if (refreshTime is Timestamp) {
        return refreshTime.toDate();
      } else {
        return null;
      }
    });
  }
}

@Riverpod(keepAlive: true)
UserMetadataRepository userMetadataRepository(Ref ref) {
  return UserMetadataRepository(firestore: FirebaseFirestore.instance);
}
