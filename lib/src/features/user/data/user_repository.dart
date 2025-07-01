import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekod_alumni/src/features/user/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// {@template user_repository}
/// Provides an interface to interact with the user data.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ImagePicker _imagePicker = ImagePicker();

  static String userPath(UserID id) => 'userProfiles/$id';
  static String userProfilePath(String uid) => 'userProfiles/$uid';

  /// Crée un nouvel utilisateur dans Firestore
  Future<void> createUser(User user) async {
    final ref = _userRef(user.id);
    await ref.set(user);
  }

  Future<User?> fetchUser(UserID id) async {
    final ref = _userRef(id);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  Stream<User?> watchUser(UserID id) {
    final ref = _userRef(id);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  /// Récupère toutes les données utilisateur depuis userProfiles
  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    try {
      final doc = await _firestore.doc(userProfilePath(uid)).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Stream pour surveiller toutes les données utilisateur
  Stream<Map<String, dynamic>?> watchUserProfile(String uid) {
    return _firestore.doc(userProfilePath(uid)).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }

  /// Récupère la bio de l'utilisateur
  Future<String?> fetchUserBio(String uid) async {
    try {
      final doc = await _firestore.doc(userProfilePath(uid)).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['bio'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Met à jour la bio de l'utilisateur
  Future<void> updateUserBio(String uid, String bio) async {
    await _firestore.doc(userProfilePath(uid)).set(
      {
        'bio': bio,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Stream pour surveiller les changements de bio
  Stream<String?> watchUserBio(String uid) {
    return _firestore.doc(userProfilePath(uid)).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        return data?['bio'] as String?;
      }
      return null;
    });
  }

  /// Sélectionne une image depuis la galerie ou l'appareil photo
  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      return null;
    }
  }

  /// Upload une image de profil et retourne l'URL
  Future<String?> uploadProfileImage(String uid, XFile imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images/$uid.jpg');

      // Utiliser les bytes pour compatibilité web et mobile
      final imageBytes = await imageFile.readAsBytes();

      final uploadTask = await ref.putData(
        imageBytes,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'userId': uid},
        ),
      );

      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      // Erreurs spécifiques Firebase
      if (kDebugMode) {
        print(
          'Firebase Storage Error - Code: ${e.code}, Message: ${e.message}',
        );
      }

      switch (e.code) {
        case 'storage/unauthorized':
          throw Exception(
            "permissions - Vous n'avez pas l'autorisation d'uploader des images",
          );
        case 'storage/canceled':
          throw Exception("L'upload a été annulé");
        case 'storage/unknown':
          throw Exception(
            "storage - Firebase Storage n'est peut-être pas configuré",
          );
        case 'storage/object-not-found':
          throw Exception(
            'storage - Problème de configuration du bucket Storage',
          );
        case 'storage/bucket-not-found':
          throw Exception("storage - Le bucket Firebase Storage n'existe pas");
        case 'storage/project-not-found':
          throw Exception('storage - Projet Firebase Storage introuvable');
        case 'storage/quota-exceeded':
          throw Exception('Quota de stockage dépassé');
        case 'storage/unauthenticated':
          throw Exception('Vous devez être connecté pour uploader une image');
        case 'storage/retry-limit-exceeded':
          throw Exception(
            'network - Trop de tentatives, vérifiez votre connexion',
          );
        default:
          throw Exception('storage - Erreur Firebase Storage: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('General Upload Error: $e');
      }
      throw Exception("Erreur générale lors de l'upload: $e");
    }
  }

  /// Met à jour l'URL de la photo de profil
  Future<void> updateProfileImageUrl(String uid, String imageUrl) async {
    await _firestore.doc(userProfilePath(uid)).set(
      {
        'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Récupère l'URL de la photo de profil
  Future<String?> fetchProfileImageUrl(String uid) async {
    try {
      final doc = await _firestore.doc(userProfilePath(uid)).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['profileImageUrl'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Stream pour surveiller les changements de photo de profil
  Stream<String?> watchProfileImageUrl(String uid) {
    return _firestore.doc(userProfilePath(uid)).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        return data?['profileImageUrl'] as String?;
      }
      return null;
    });
  }

  /// Récupère les informations professionnelles de l'utilisateur
  Future<Map<String, String?>> fetchProfessionalInfo(String uid) async {
    try {
      final doc = await _firestore.doc(userProfilePath(uid)).get();
      if (doc.exists) {
        final data = doc.data();
        return {
          'entreprise': data?['entreprise'] as String?,
          'poste': data?['poste'] as String?,
          'ville': data?['ville'] as String?,
          'anneePromotion': data?['anneePromotion'] as String?,
        };
      }
      return {
        'entreprise': null,
        'poste': null,
        'ville': null,
        'anneePromotion': null,
      };
    } catch (e) {
      return {
        'entreprise': null,
        'poste': null,
        'ville': null,
        'anneePromotion': null,
      };
    }
  }

  /// Met à jour les informations professionnelles de l'utilisateur
  Future<void> updateProfessionalInfo(
    String uid, {
    String? entreprise,
    String? poste,
    String? ville,
    String? anneePromotion,
  }) async {
    final updateData = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (entreprise != null) updateData['entreprise'] = entreprise;
    if (poste != null) updateData['poste'] = poste;
    if (ville != null) updateData['ville'] = ville;
    if (anneePromotion != null) updateData['anneePromotion'] = anneePromotion;

    await _firestore.doc(userProfilePath(uid)).set(
          updateData,
          SetOptions(merge: true),
        );
  }

  /// Stream pour surveiller les changements des informations professionnelles
  Stream<Map<String, String?>> watchProfessionalInfo(String uid) {
    return _firestore.doc(userProfilePath(uid)).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        return {
          'entreprise': data?['entreprise'] as String?,
          'poste': data?['poste'] as String?,
          'ville': data?['ville'] as String?,
          'anneePromotion': data?['anneePromotion'] as String?,
        };
      }
      return {
        'entreprise': null,
        'poste': null,
        'ville': null,
        'anneePromotion': null,
      };
    });
  }

  /// Récupère le statut de l'utilisateur
  Future<String?> fetchUserStatus(String uid) async {
    try {
      final doc = await _firestore.doc(userPath(uid)).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['statut'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Stream pour surveiller les changements de statut
  Stream<String?> watchUserStatus(String uid) {
    return _firestore.doc(userPath(uid)).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        return data?['statut'] as String?;
      }
      return null;
    });
  }

  /// Supprime la photo de profil actuelle
  Future<void> deleteProfileImage(String uid) async {
    try {
      // Supprimer de Firebase Storage
      final ref = _storage.ref().child('profile_images/$uid.jpg');
      await ref.delete();

      // Supprimer l'URL de Firestore
      await _firestore.doc(userProfilePath(uid)).update({
        'profileImageUrl': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Gérer l'erreur si l'image n'existe pas
    }
  }

  DocumentReference<User> _userRef(UserID id) {
    return _firestore.doc(userPath(id)).withConverter(
          fromFirestore: (doc, _) => User.fromJson(doc.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});

// Provider pour la bio de l'utilisateur
final userBioProvider =
    FutureProvider.family<String?, String>((ref, uid) async {
  return ref.watch(userRepositoryProvider).fetchUserBio(uid);
});

final userBioStreamProvider =
    StreamProvider.family<String?, String>((ref, uid) {
  return ref.watch(userRepositoryProvider).watchUserBio(uid);
});

// Provider pour la photo de profil de l'utilisateur
final userProfileImageProvider =
    FutureProvider.family<String?, String>((ref, uid) async {
  return ref.watch(userRepositoryProvider).fetchProfileImageUrl(uid);
});

final userProfileImageStreamProvider =
    StreamProvider.family<String?, String>((ref, uid) {
  return ref.watch(userRepositoryProvider).watchProfileImageUrl(uid);
});

// Provider pour les informations professionnelles de l'utilisateur
final userProfessionalInfoProvider =
    FutureProvider.family<Map<String, String?>, String>((ref, uid) async {
  return ref.watch(userRepositoryProvider).fetchProfessionalInfo(uid);
});

final userProfessionalInfoStreamProvider =
    StreamProvider.family<Map<String, String?>, String>((ref, uid) {
  return ref.watch(userRepositoryProvider).watchProfessionalInfo(uid);
});

// Provider pour le statut de l'utilisateur
final userStatusProvider =
    FutureProvider.family<String?, String>((ref, uid) async {
  return ref.watch(userRepositoryProvider).fetchUserStatus(uid);
});

final userStatusStreamProvider =
    StreamProvider.family<String?, String>((ref, uid) {
  return ref.watch(userRepositoryProvider).watchUserStatus(uid);
});

// Provider pour le profil utilisateur complet depuis userProfiles
final userProfileProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, uid) async {
  return ref.watch(userRepositoryProvider).fetchUserProfile(uid);
});

final userProfileStreamProvider =
    StreamProvider.family<Map<String, dynamic>?, String>((ref, uid) {
  return ref.watch(userRepositoryProvider).watchUserProfile(uid);
});

// Provider pour les informations utilisateur complètes (ancienne méthode)
final userDataProvider = FutureProvider.family<User?, String>((ref, uid) async {
  return ref.watch(userRepositoryProvider).fetchUser(uid);
});

final userDataStreamProvider = StreamProvider.family<User?, String>((ref, uid) {
  return ref.watch(userRepositoryProvider).watchUser(uid);
});
