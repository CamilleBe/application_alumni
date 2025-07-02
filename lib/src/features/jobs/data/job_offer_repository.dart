import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekod_alumni/src/features/jobs/domain/job_offer.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// {@template job_offer_repository}
/// Repository pour gérer les données des offres d'emploi et de stage
/// {@endtemplate}
class JobOfferRepository {
  /// {@macro job_offer_repository}
  JobOfferRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  static const String _collectionPath = 'jobOffers';

  /// Récupère toutes les offres d'emploi actives
  Future<List<JobOffer>> fetchAllJobOffers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .orderBy('datePublication', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => JobOffer.fromJson({
              'id': doc.id,
              ...doc.data(),
            }),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des offres: $e');
      }
      return [];
    }
  }

  /// Stream pour surveiller toutes les offres en temps réel
  Stream<List<JobOffer>> watchAllJobOffers() {
    return _firestore
        .collection(_collectionPath)
        .orderBy('datePublication', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => JobOffer.fromJson({
              'id': doc.id,
              ...doc.data(),
            }),
          )
          .toList();
    });
  }

  /// Récupère les offres actives uniquement
  Future<List<JobOffer>> fetchActiveJobOffers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'active')
          .orderBy('datePublication', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => JobOffer.fromJson({
              'id': doc.id,
              ...doc.data(),
            }),
          )
          .where((offer) => offer.isActive)
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des offres actives: $e');
      }
      return [];
    }
  }

  /// Récupère une offre spécifique par son ID
  Future<JobOffer?> fetchJobOfferById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(id).get();

      if (doc.exists && doc.data() != null) {
        return JobOffer.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération de l'offre $id: $e");
      }
      return null;
    }
  }

  /// Stream pour surveiller une offre spécifique
  Stream<JobOffer?> watchJobOffer(String id) {
    return _firestore
        .collection(_collectionPath)
        .doc(id)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return JobOffer.fromJson({
          'id': snapshot.id,
          ...snapshot.data()!,
        });
      }
      return null;
    });
  }

  /// Récupère les offres publiées par un utilisateur spécifique
  Future<List<JobOffer>> fetchJobOffersByPublisher(String publisherId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('publisherId', isEqualTo: publisherId)
          .orderBy('datePublication', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => JobOffer.fromJson({
              'id': doc.id,
              ...doc.data(),
            }),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(
          'Erreur lors de la récupération des offres du publisher $publisherId: $e',
        );
      }
      return [];
    }
  }

  /// Filtre les offres par type (stage ou emploi)
  Future<List<JobOffer>> filterJobOffersByType(JobOfferType type) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('type', isEqualTo: type.name)
          .where('statut', isEqualTo: 'active')
          .orderBy('datePublication', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => JobOffer.fromJson({
              'id': doc.id,
              ...doc.data(),
            }),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du filtrage par type: $e');
      }
      return [];
    }
  }

  /// Filtre les offres par ville
  Future<List<JobOffer>> filterJobOffersByCity(String city) async {
    if (city.trim().isEmpty) {
      return fetchActiveJobOffers();
    }

    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('ville', isEqualTo: city)
          .where('statut', isEqualTo: 'active')
          .orderBy('datePublication', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => JobOffer.fromJson({
              'id': doc.id,
              ...doc.data(),
            }),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du filtrage par ville: $e');
      }
      return [];
    }
  }

  /// Recherche d'offres par titre ou entreprise
  Future<List<JobOffer>> searchJobOffers(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      return fetchActiveJobOffers();
    }

    try {
      // Récupérer toutes les offres actives puis filtrer côté client
      // (Firestore ne supporte pas les recherches full-text natives)
      final allOffers = await fetchActiveJobOffers();
      final normalizedSearch = searchTerm.toLowerCase().trim();

      return allOffers.where((offer) {
        final titleLower = offer.titre.toLowerCase();
        final companyLower = offer.entreprise.toLowerCase();
        final descriptionLower = offer.description.toLowerCase();

        return titleLower.contains(normalizedSearch) ||
            companyLower.contains(normalizedSearch) ||
            descriptionLower.contains(normalizedSearch);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la recherche d'offres: $e");
      }
      return [];
    }
  }

  /// Filtrage avancé avec plusieurs critères
  Future<List<JobOffer>> filterJobOffers({
    String? searchTerm,
    JobOfferType? type,
    String? city,
    String? company,
  }) async {
    try {
      var query = _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'active');

      // Ajouter les filtres Firestore disponibles
      if (type != null) {
        query = query.where('type', isEqualTo: type.name);
      }
      if (city?.isNotEmpty ?? false) {
        query = query.where('ville', isEqualTo: city);
      }
      if (company?.isNotEmpty ?? false) {
        query = query.where('entreprise', isEqualTo: company);
      }

      query = query.orderBy('datePublication', descending: true);

      final querySnapshot = await query.get();
      var offers = querySnapshot.docs
          .map(
            (doc) => JobOffer.fromJson({
              'id': doc.id,
              ...doc.data(),
            }),
          )
          .toList();

      // Filtrage côté client pour la recherche par terme
      if (searchTerm?.isNotEmpty ?? false) {
        final normalizedSearch = searchTerm!.toLowerCase().trim();
        offers = offers.where((offer) {
          final titleLower = offer.titre.toLowerCase();
          final companyLower = offer.entreprise.toLowerCase();
          return titleLower.contains(normalizedSearch) ||
              companyLower.contains(normalizedSearch);
        }).toList();
      }

      return offers;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du filtrage avancé: $e');
      }
      return [];
    }
  }

  /// Crée une nouvelle offre d'emploi
  Future<String?> createJobOffer(JobOffer offer) async {
    try {
      final offerData = offer.toJson();
      offerData.remove('id'); // Laisser Firestore générer l'ID

      final docRef =
          await _firestore.collection(_collectionPath).add(offerData);
      return docRef.id;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création de l'offre: $e");
      }
      return null;
    }
  }

  /// Met à jour une offre existante
  Future<bool> updateJobOffer(String id, JobOffer updatedOffer) async {
    try {
      final offerData = updatedOffer.toJson();
      offerData.remove('id'); // Ne pas inclure l'ID dans les données

      await _firestore.collection(_collectionPath).doc(id).update(offerData);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la mise à jour de l'offre $id: $e");
      }
      return false;
    }
  }

  /// Supprime une offre
  Future<bool> deleteJobOffer(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la suppression de l'offre $id: $e");
      }
      return false;
    }
  }

  /// Change le statut d'une offre
  Future<bool> updateJobOfferStatus(String id, JobOfferStatus newStatus) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).update({
        'statut': newStatus.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors du changement de statut de l'offre $id: $e");
      }
      return false;
    }
  }
}

/// Provider pour le JobOfferRepository
final jobOfferRepositoryProvider = Provider<JobOfferRepository>((ref) {
  return JobOfferRepository(
    firestore: FirebaseFirestore.instance,
  );
});
