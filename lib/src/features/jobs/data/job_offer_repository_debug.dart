import 'package:ekod_alumni/src/features/jobs/domain/job_offer.dart';
import 'package:ekod_alumni/src/features/jobs/data/job_offer_test_data.dart';
import 'package:flutter/foundation.dart';

/// Version debug du JobOfferRepository qui utilise des données locales
/// Utile pour le développement sans connexion Firebase
class JobOfferRepositoryDebug {
  JobOfferRepositoryDebug();

  // Simulation d'une base de données locale
  static List<JobOffer> _localJobOffers = [...JobOfferTestData.sampleJobOffers];

  /// Récupère toutes les offres d'emploi
  Future<List<JobOffer>> fetchAllJobOffers() async {
    // Simulation d'un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_localJobOffers)
      ..sort((a, b) => b.datePublication.compareTo(a.datePublication));
  }

  /// Stream pour surveiller toutes les offres en temps réel
  Stream<List<JobOffer>> watchAllJobOffers() async* {
    while (true) {
      yield List.from(_localJobOffers)
        ..sort((a, b) => b.datePublication.compareTo(a.datePublication));
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// Récupère les offres actives uniquement
  Future<List<JobOffer>> fetchActiveJobOffers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _localJobOffers.where((offer) => offer.isActive).toList()
      ..sort((a, b) => b.datePublication.compareTo(a.datePublication));
  }

  /// Récupère une offre spécifique par son ID
  Future<JobOffer?> fetchJobOfferById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _localJobOffers.firstWhere((offer) => offer.id == id);
    } catch (e) {
      if (kDebugMode) {
        print('Offre non trouvée: $id');
      }
      return null;
    }
  }

  /// Stream pour surveiller une offre spécifique
  Stream<JobOffer?> watchJobOffer(String id) async* {
    while (true) {
      try {
        yield _localJobOffers.firstWhere((offer) => offer.id == id);
      } catch (e) {
        yield null;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// Récupère les offres publiées par un utilisateur spécifique
  Future<List<JobOffer>> fetchJobOffersByPublisher(String publisherId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _localJobOffers
        .where((offer) => offer.publisherId == publisherId)
        .toList()
      ..sort((a, b) => b.datePublication.compareTo(a.datePublication));
  }

  /// Filtre les offres par type (stage ou emploi)
  Future<List<JobOffer>> filterJobOffersByType(JobOfferType type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _localJobOffers
        .where((offer) => offer.type == type && offer.isActive)
        .toList()
      ..sort((a, b) => b.datePublication.compareTo(a.datePublication));
  }

  /// Filtre les offres par ville
  Future<List<JobOffer>> filterJobOffersByCity(String city) async {
    if (city.trim().isEmpty) {
      return fetchActiveJobOffers();
    }

    await Future.delayed(const Duration(milliseconds: 300));
    return _localJobOffers
        .where((offer) => offer.ville == city && offer.isActive)
        .toList()
      ..sort((a, b) => b.datePublication.compareTo(a.datePublication));
  }

  /// Recherche d'offres par titre ou entreprise
  Future<List<JobOffer>> searchJobOffers(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      return fetchActiveJobOffers();
    }

    await Future.delayed(const Duration(milliseconds: 400));
    final normalizedSearch = searchTerm.toLowerCase().trim();

    return _localJobOffers.where((offer) {
      if (!offer.isActive) return false;

      final titleLower = offer.titre.toLowerCase();
      final companyLower = offer.entreprise.toLowerCase();
      final descriptionLower = offer.description.toLowerCase();

      return titleLower.contains(normalizedSearch) ||
          companyLower.contains(normalizedSearch) ||
          descriptionLower.contains(normalizedSearch);
    }).toList()
      ..sort((a, b) => b.datePublication.compareTo(a.datePublication));
  }

  /// Filtrage avancé avec plusieurs critères
  Future<List<JobOffer>> filterJobOffers({
    String? searchTerm,
    JobOfferType? type,
    String? city,
    String? company,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    var filteredOffers = _localJobOffers.where((offer) => offer.isActive);

    // Filtrer par type
    if (type != null) {
      filteredOffers = filteredOffers.where((offer) => offer.type == type);
    }

    // Filtrer par ville
    if (city?.isNotEmpty ?? false) {
      filteredOffers = filteredOffers.where((offer) => offer.ville == city);
    }

    // Filtrer par entreprise
    if (company?.isNotEmpty ?? false) {
      filteredOffers =
          filteredOffers.where((offer) => offer.entreprise == company);
    }

    // Recherche par terme
    if (searchTerm?.isNotEmpty ?? false) {
      final normalizedSearch = searchTerm!.toLowerCase().trim();
      filteredOffers = filteredOffers.where((offer) {
        final titleLower = offer.titre.toLowerCase();
        final companyLower = offer.entreprise.toLowerCase();
        return titleLower.contains(normalizedSearch) ||
            companyLower.contains(normalizedSearch);
      });
    }

    return filteredOffers.toList()
      ..sort((a, b) => b.datePublication.compareTo(a.datePublication));
  }

  /// Crée une nouvelle offre d'emploi
  Future<String?> createJobOffer(JobOffer offer) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Générer un nouvel ID
      final newId = 'job_${DateTime.now().millisecondsSinceEpoch}';

      final newOffer = offer.copyWith(
        id: newId,
        datePublication: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _localJobOffers.add(newOffer);

      if (kDebugMode) {
        print('Nouvelle offre créée: ${newOffer.titre}');
      }

      return newId;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création de l'offre: $e");
      }
      return null;
    }
  }

  /// Met à jour une offre existante
  Future<bool> updateJobOffer(String id, JobOffer updatedOffer) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final index = _localJobOffers.indexWhere((offer) => offer.id == id);

      if (index != -1) {
        _localJobOffers[index] = updatedOffer.copyWith(
          id: id,
          updatedAt: DateTime.now(),
        );

        if (kDebugMode) {
          print('Offre mise à jour: ${updatedOffer.titre}');
        }

        return true;
      } else {
        if (kDebugMode) {
          print('Offre non trouvée pour mise à jour: $id');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la mise à jour de l'offre $id: $e");
      }
      return false;
    }
  }

  /// Supprime une offre
  Future<bool> deleteJobOffer(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final initialLength = _localJobOffers.length;
      _localJobOffers.removeWhere((offer) => offer.id == id);

      final success = _localJobOffers.length < initialLength;

      if (success && kDebugMode) {
        print('Offre supprimée: $id');
      }

      return success;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la suppression de l'offre $id: $e");
      }
      return false;
    }
  }

  /// Change le statut d'une offre
  Future<bool> updateJobOfferStatus(String id, JobOfferStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final index = _localJobOffers.indexWhere((offer) => offer.id == id);

      if (index != -1) {
        _localJobOffers[index] = _localJobOffers[index].copyWith(
          statut: newStatus,
          updatedAt: DateTime.now(),
        );

        if (kDebugMode) {
          print("Statut mis à jour pour l'offre $id: ${newStatus.displayName}");
        }

        return true;
      } else {
        if (kDebugMode) {
          print('Offre non trouvée pour changement de statut: $id');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors du changement de statut de l'offre $id: $e");
      }
      return false;
    }
  }

  /// Méthodes utilitaires pour les données de test

  /// Remet les données à leur état initial
  void resetData() {
    _localJobOffers = [...JobOfferTestData.sampleJobOffers];
    if (kDebugMode) {
      print('Données de test remises à zéro');
    }
  }

  /// Ajoute des offres de test supplémentaires
  void addSampleData() {
    _localJobOffers.addAll(JobOfferTestData.sampleJobOffers);
    if (kDebugMode) {
      print('Données de test ajoutées');
    }
  }

  /// Retourne les statistiques actuelles
  Map<String, int> getStats() {
    final total = _localJobOffers.length;
    final active = _localJobOffers.where((offer) => offer.isActive).length;
    final stages = _localJobOffers
        .where((offer) => offer.type == JobOfferType.stage)
        .length;
    final emplois = _localJobOffers
        .where((offer) => offer.type == JobOfferType.emploi)
        .length;

    return {
      'total': total,
      'active': active,
      'stages': stages,
      'emplois': emplois,
    };
  }
}
