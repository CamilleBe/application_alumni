import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekod_alumni/src/features/alumni/alumni.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// {@template alumni_repository}
/// Repository pour gérer les données des alumni
/// {@endtemplate}
class AlumniRepository {
  /// {@macro alumni_repository}
  AlumniRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  static const String _collectionPath = 'userProfiles';

  /// Récupère tous les alumni (utilisateurs avec statut "Alumni")
  Future<List<Alumni>> fetchAllAlumni() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'Alumni')
          .get();

      return querySnapshot.docs
          .map((doc) => _convertToAlumni(doc.data(), doc.id))
          .where((alumni) => alumni != null)
          .cast<Alumni>()
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des alumni: $e');
      }
      return [];
    }
  }

  /// Stream pour surveiller tous les alumni en temps réel
  Stream<List<Alumni>> watchAllAlumni() {
    return _firestore
        .collection(_collectionPath)
        .where('statut', isEqualTo: 'Alumni')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => _convertToAlumni(doc.data(), doc.id))
          .where((alumni) => alumni != null)
          .cast<Alumni>()
          .toList();
    });
  }

  /// Recherche d'alumni par nom (prénom ou nom de famille)
  Future<List<Alumni>> searchAlumniByName(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      return fetchAllAlumni();
    }

    try {
      final normalizedSearch = searchTerm.toLowerCase().trim();

      // Récupérer tous les alumni puis filtrer côté client
      // (Firestore ne supporte pas les recherches full-text natives)
      final allAlumni = await fetchAllAlumni();

      return allAlumni.where((alumni) {
        final fullNameLower = alumni.fullName.toLowerCase();
        final firstNameLower = alumni.firstName.toLowerCase();
        final lastNameLower = alumni.lastName.toLowerCase();

        return fullNameLower.contains(normalizedSearch) ||
            firstNameLower.contains(normalizedSearch) ||
            lastNameLower.contains(normalizedSearch);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la recherche d'alumni: $e");
      }
      return [];
    }
  }

  /// Filtre les alumni par ville
  Future<List<Alumni>> filterAlumniByCity(String city) async {
    if (city.trim().isEmpty) {
      return fetchAllAlumni();
    }

    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'Alumni')
          .where('ville', isEqualTo: city)
          .get();

      return querySnapshot.docs
          .map((doc) => _convertToAlumni(doc.data(), doc.id))
          .where((alumni) => alumni != null)
          .cast<Alumni>()
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du filtrage par ville: $e');
      }
      return [];
    }
  }

  /// Filtre les alumni par entreprise
  Future<List<Alumni>> filterAlumniByCompany(String company) async {
    if (company.trim().isEmpty) {
      return fetchAllAlumni();
    }

    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'Alumni')
          .where('entreprise', isEqualTo: company)
          .get();

      return querySnapshot.docs
          .map((doc) => _convertToAlumni(doc.data(), doc.id))
          .where((alumni) => alumni != null)
          .cast<Alumni>()
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du filtrage par entreprise: $e');
      }
      return [];
    }
  }

  /// Filtre les alumni par année de promotion
  Future<List<Alumni>> filterAlumniByYear(String year) async {
    if (year.trim().isEmpty) {
      return fetchAllAlumni();
    }

    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'Alumni')
          .where('anneePromotion', isEqualTo: year)
          .get();

      return querySnapshot.docs
          .map((doc) => _convertToAlumni(doc.data(), doc.id))
          .where((alumni) => alumni != null)
          .cast<Alumni>()
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du filtrage par année: $e');
      }
      return [];
    }
  }

  /// Filtrage avancé avec plusieurs critères
  Future<List<Alumni>> filterAlumni({
    String? searchTerm,
    String? city,
    String? company,
    String? year,
  }) async {
    try {
      // Commencer par récupérer les alumni de base
      var query = _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'Alumni');

      // Ajouter les filtres Firestore disponibles
      if (city?.isNotEmpty ?? false) {
        query = query.where('ville', isEqualTo: city);
      }
      if (company?.isNotEmpty ?? false) {
        query = query.where('entreprise', isEqualTo: company);
      }
      if (year?.isNotEmpty ?? false) {
        query = query.where('anneePromotion', isEqualTo: year);
      }

      final querySnapshot = await query.get();
      var alumni = querySnapshot.docs
          .map((doc) => _convertToAlumni(doc.data(), doc.id))
          .where((alumni) => alumni != null)
          .cast<Alumni>()
          .toList();

      // Filtrage côté client pour la recherche par nom
      if (searchTerm?.isNotEmpty ?? false) {
        final normalizedSearch = searchTerm!.toLowerCase().trim();
        alumni = alumni.where((alumni) {
          final fullNameLower = alumni.fullName.toLowerCase();
          return fullNameLower.contains(normalizedSearch);
        }).toList();
      }

      return alumni;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du filtrage avancé: $e');
      }
      return [];
    }
  }

  /// Récupère un alumni spécifique par son ID
  Future<Alumni?> fetchAlumniById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(id).get();

      if (doc.exists) {
        final data = doc.data()!;
        // Vérifier que c'est bien un alumni
        if (data['statut'] == 'Alumni') {
          return _convertToAlumni(data, doc.id);
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération de l'alumni $id: $e");
      }
      return null;
    }
  }

  /// Récupère les villes disponibles pour le filtrage
  Future<List<String>> getAvailableCities() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'Alumni')
          .get();

      final cities = <String>{};
      for (final doc in querySnapshot.docs) {
        final ville = doc.data()['ville'] as String?;
        if (ville?.isNotEmpty ?? false) {
          cities.add(ville!);
        }
      }

      final cityList = cities.toList()..sort();
      return cityList;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des villes: $e');
      }
      return [];
    }
  }

  /// Récupère les entreprises disponibles pour le filtrage
  Future<List<String>> getAvailableCompanies() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'Alumni')
          .get();

      final companies = <String>{};
      for (final doc in querySnapshot.docs) {
        final entreprise = doc.data()['entreprise'] as String?;
        if (entreprise?.isNotEmpty ?? false) {
          companies.add(entreprise!);
        }
      }

      final companyList = companies.toList()..sort();
      return companyList;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des entreprises: $e');
      }
      return [];
    }
  }

  /// Récupère les années de promotion disponibles pour le filtrage
  Future<List<String>> getAvailableYears() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'Alumni')
          .get();

      final years = <String>{};
      for (final doc in querySnapshot.docs) {
        final anneePromotion = doc.data()['anneePromotion'] as String?;
        if (anneePromotion?.isNotEmpty ?? false) {
          years.add(anneePromotion!);
        }
      }

      final yearList = years.toList()
        ..sort((a, b) => b.compareTo(a)); // Plus récent en premier
      return yearList;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des années: $e');
      }
      return [];
    }
  }

  /// Convertit les données Firestore en modèle Alumni
  Alumni? _convertToAlumni(Map<String, dynamic> data, String docId) {
    try {
      // Vérifier que les champs essentiels sont présents
      if (data['firstName'] == null ||
          data['lastName'] == null ||
          data['email'] == null) {
        return null;
      }

      return Alumni(
        id: docId,
        firstName: data['firstName'] as String,
        lastName: data['lastName'] as String,
        email: data['email'] as String,
        statut: data['statut'] as String?,
        entreprise: data['entreprise'] as String?,
        poste: data['poste'] as String?,
        ville: data['ville'] as String?,
        anneePromotion: data['anneePromotion'] as String?,
        bio: data['bio'] as String?,
        profileImageUrl: data['profileImageUrl'] as String?,
        createdAt: data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : null,
        updatedAt: data['updatedAt'] != null
            ? (data['updatedAt'] as Timestamp).toDate()
            : null,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la conversion des données alumni: $e');
      }
      return null;
    }
  }
}

// Provider pour le AlumniRepository
final alumniRepositoryProvider = Provider<AlumniRepository>((ref) {
  return AlumniRepository(
    firestore: FirebaseFirestore.instance,
  );
});

// Provider pour récupérer tous les alumni
final allAlumniProvider = FutureProvider<List<Alumni>>((ref) async {
  return ref.watch(alumniRepositoryProvider).fetchAllAlumni();
});

// Stream provider pour les alumni en temps réel
final alumniStreamProvider = StreamProvider<List<Alumni>>((ref) {
  return ref.watch(alumniRepositoryProvider).watchAllAlumni();
});

// Provider pour récupérer les options de filtrage
final availableCitiesProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(alumniRepositoryProvider).getAvailableCities();
});

final availableCompaniesProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(alumniRepositoryProvider).getAvailableCompanies();
});

final availableYearsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(alumniRepositoryProvider).getAvailableYears();
});

// Provider pour un alumni spécifique
final alumniByIdProvider =
    FutureProvider.family<Alumni?, String>((ref, id) async {
  return ref.watch(alumniRepositoryProvider).fetchAlumniById(id);
});
