import 'package:ekod_alumni/src/features/authentication/authentication.dart';
import 'package:ekod_alumni/src/features/jobs/data/job_offer_repository.dart';
import 'package:ekod_alumni/src/features/jobs/data/job_offer_repository_debug.dart';
import 'package:ekod_alumni/src/features/jobs/domain/job_offer.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Service pour gérer la logique métier des offres d'emploi
class JobOfferService {
  JobOfferService(this.ref);

  final Ref ref;

  /// Instance du repository debug pour le développement
  final JobOfferRepositoryDebug _debugRepository = JobOfferRepositoryDebug();

  /// Récupère le repository approprié selon l'environnement
  JobOfferRepository get _firebaseRepository =>
      ref.read(jobOfferRepositoryProvider);

  /// Récupère toutes les offres actives
  Future<List<JobOffer>> getAllActiveOffers() async {
    if (kDebugMode) {
      return _debugRepository.fetchActiveJobOffers();
    } else {
      return _firebaseRepository.fetchActiveJobOffers();
    }
  }

  /// Recherche des offres par terme
  Future<List<JobOffer>> searchOffers(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      return getAllActiveOffers();
    }
    if (kDebugMode) {
      return _debugRepository.searchJobOffers(searchTerm);
    } else {
      return _firebaseRepository.searchJobOffers(searchTerm);
    }
  }

  /// Filtre les offres selon plusieurs critères
  Future<List<JobOffer>> filterOffers({
    String? searchTerm,
    JobOfferType? type,
    String? city,
    String? company,
  }) async {
    if (kDebugMode) {
      return _debugRepository.filterJobOffers(
        searchTerm: searchTerm,
        type: type,
        city: city,
        company: company,
      );
    } else {
      return _firebaseRepository.filterJobOffers(
        searchTerm: searchTerm,
        type: type,
        city: city,
        company: company,
      );
    }
  }

  /// Récupère une offre spécifique par son ID
  Future<JobOffer?> getOfferById(String id) async {
    if (kDebugMode) {
      return _debugRepository.fetchJobOfferById(id);
    } else {
      return _firebaseRepository.fetchJobOfferById(id);
    }
  }

  /// Récupère les offres d'un utilisateur spécifique
  Future<List<JobOffer>> getOffersByPublisher(String publisherId) async {
    if (kDebugMode) {
      return _debugRepository.fetchJobOffersByPublisher(publisherId);
    } else {
      return _firebaseRepository.fetchJobOffersByPublisher(publisherId);
    }
  }

  /// Récupère les offres de l'utilisateur actuel
  Future<List<JobOffer>> getCurrentUserOffers() async {
    final currentUser = ref.read(authStateChangesProvider).value;
    if (currentUser == null) {
      throw Exception('Utilisateur non connecté');
    }
    return getOffersByPublisher(currentUser.uid);
  }

  /// Vérifie si l'utilisateur actuel peut publier des offres
  /// (doit être Alumni)
  Future<bool> canCurrentUserPublishOffers() async {
    final currentUser = ref.read(authStateChangesProvider).value;
    if (currentUser == null) return false;

    // TODO: Récupérer le statut de l'utilisateur depuis le profil
    // Pour l'instant, on autorise tous les utilisateurs connectés
    return true;
  }

  /// Crée une nouvelle offre d'emploi
  Future<String?> createOffer(JobOffer offer) async {
    final currentUser = ref.read(authStateChangesProvider).value;
    if (currentUser == null) {
      throw Exception('Vous devez être connecté pour publier une offre');
    }

    final canPublish = await canCurrentUserPublishOffers();
    if (!canPublish) {
      throw Exception('Seuls les alumni peuvent publier des offres');
    }

    // Assigner l'utilisateur actuel comme publisher
    final offerWithPublisher = offer.copyWith(
      publisherId: currentUser.uid,
      datePublication: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (kDebugMode) {
      return _debugRepository.createJobOffer(offerWithPublisher);
    } else {
      return _firebaseRepository.createJobOffer(offerWithPublisher);
    }
  }

  /// Met à jour une offre existante
  Future<bool> updateOffer(String id, JobOffer updatedOffer) async {
    final currentUser = ref.read(authStateChangesProvider).value;
    if (currentUser == null) {
      throw Exception('Vous devez être connecté pour modifier une offre');
    }

    // Vérifier que l'utilisateur est le propriétaire de l'offre
    final existingOffer = await getOfferById(id);
    if (existingOffer == null) {
      throw Exception('Offre non trouvée');
    }

    if (existingOffer.publisherId != currentUser.uid) {
      throw Exception('Vous ne pouvez modifier que vos propres offres');
    }

    // Mettre à jour avec timestamp
    final offerWithTimestamp = updatedOffer.copyWith(
      updatedAt: DateTime.now(),
    );

    if (kDebugMode) {
      return _debugRepository.updateJobOffer(id, offerWithTimestamp);
    } else {
      return _firebaseRepository.updateJobOffer(id, offerWithTimestamp);
    }
  }

  /// Supprime une offre
  Future<bool> deleteOffer(String id) async {
    final currentUser = ref.read(authStateChangesProvider).value;
    if (currentUser == null) {
      throw Exception('Vous devez être connecté pour supprimer une offre');
    }

    // Vérifier que l'utilisateur est le propriétaire de l'offre
    final existingOffer = await getOfferById(id);
    if (existingOffer == null) {
      throw Exception('Offre non trouvée');
    }

    if (existingOffer.publisherId != currentUser.uid) {
      throw Exception('Vous ne pouvez supprimer que vos propres offres');
    }

    if (kDebugMode) {
      return _debugRepository.deleteJobOffer(id);
    } else {
      return _firebaseRepository.deleteJobOffer(id);
    }
  }

  /// Change le statut d'une offre
  Future<bool> changeOfferStatus(String id, JobOfferStatus newStatus) async {
    final currentUser = ref.read(authStateChangesProvider).value;
    if (currentUser == null) {
      throw Exception('Vous devez être connecté pour modifier le statut');
    }

    // Vérifier que l'utilisateur est le propriétaire de l'offre
    final existingOffer = await getOfferById(id);
    if (existingOffer == null) {
      throw Exception('Offre non trouvée');
    }

    if (existingOffer.publisherId != currentUser.uid) {
      throw Exception('Vous ne pouvez modifier que vos propres offres');
    }

    if (kDebugMode) {
      return _debugRepository.updateJobOfferStatus(id, newStatus);
    } else {
      return _firebaseRepository.updateJobOfferStatus(id, newStatus);
    }
  }

  /// Récupère les villes disponibles pour les filtres
  Future<List<String>> getAvailableCities() async {
    final offers = await getAllActiveOffers();
    final cities = offers.map((offer) => offer.ville).toSet().toList();
    cities.sort();
    return cities;
  }

  /// Récupère les entreprises disponibles pour les filtres
  Future<List<String>> getAvailableCompanies() async {
    final offers = await getAllActiveOffers();
    final companies = offers.map((offer) => offer.entreprise).toSet().toList();
    companies.sort();
    return companies;
  }

  /// Récupère les compétences populaires
  Future<List<String>> getPopularSkills() async {
    final offers = await getAllActiveOffers();
    final allSkills =
        offers.expand((offer) => offer.competencesRequises).toList();

    final skillCount = <String, int>{};
    for (final skill in allSkills) {
      skillCount[skill] = (skillCount[skill] ?? 0) + 1;
    }

    final sortedSkills = skillCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedSkills.map((entry) => entry.key).take(10).toList();
  }

  /// Statistiques des offres
  Future<Map<String, int>> getOffersStats() async {
    if (kDebugMode) {
      return _debugRepository.getStats();
    } else {
      final allOffers = await _firebaseRepository.fetchAllJobOffers();
      final activeOffers = allOffers.where((offer) => offer.isActive).length;
      final stageOffers =
          allOffers.where((offer) => offer.type == JobOfferType.stage).length;
      final jobOffers =
          allOffers.where((offer) => offer.type == JobOfferType.emploi).length;

      return {
        'total': allOffers.length,
        'active': activeOffers,
        'stages': stageOffers,
        'emplois': jobOffers,
      };
    }
  }
}

/// Provider pour le JobOfferService
final jobOfferServiceProvider = Provider<JobOfferService>((ref) {
  return JobOfferService(ref);
});

/// Providers pour les différents cas d'usage

final allActiveJobOffersProvider = FutureProvider<List<JobOffer>>((ref) {
  return ref.watch(jobOfferServiceProvider).getAllActiveOffers();
});

final currentUserJobOffersProvider = FutureProvider<List<JobOffer>>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  if (authState.value == null) {
    return <JobOffer>[];
  }
  return ref.watch(jobOfferServiceProvider).getCurrentUserOffers();
});

final jobOfferByIdProvider =
    FutureProvider.family<JobOffer?, String>((ref, id) {
  return ref.watch(jobOfferServiceProvider).getOfferById(id);
});

final jobOffersStatsProvider = FutureProvider<Map<String, int>>((ref) {
  return ref.watch(jobOfferServiceProvider).getOffersStats();
});
