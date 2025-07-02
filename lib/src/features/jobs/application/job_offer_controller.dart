import 'package:ekod_alumni/src/features/jobs/application/job_offer_service.dart';
import 'package:ekod_alumni/src/features/jobs/domain/job_offer.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// État pour la liste des offres d'emploi avec filtres
@immutable
class JobOffersState {
  const JobOffersState({
    required this.offers,
    required this.isLoading,
    required this.error,
    required this.searchTerm,
    required this.selectedType,
    required this.selectedCity,
    required this.selectedCompany,
  });

  final List<JobOffer> offers;
  final bool isLoading;
  final String? error;
  final String searchTerm;
  final JobOfferType? selectedType;
  final String? selectedCity;
  final String? selectedCompany;

  JobOffersState copyWith({
    List<JobOffer>? offers,
    bool? isLoading,
    String? error,
    String? searchTerm,
    JobOfferType? selectedType,
    String? selectedCity,
    String? selectedCompany,
  }) {
    return JobOffersState(
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchTerm: searchTerm ?? this.searchTerm,
      selectedType: selectedType ?? this.selectedType,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedCompany: selectedCompany ?? this.selectedCompany,
    );
  }

  static const initial = JobOffersState(
    offers: [],
    isLoading: false,
    error: null,
    searchTerm: '',
    selectedType: null,
    selectedCity: null,
    selectedCompany: null,
  );
}

/// Controller pour gérer l'état des offres d'emploi
class JobOfferController extends StateNotifier<JobOffersState> {
  JobOfferController(this._ref) : super(JobOffersState.initial) {
    loadOffers();
  }

  final Ref _ref;

  JobOfferService get _service => _ref.read(jobOfferServiceProvider);

  /// Charge toutes les offres actives
  Future<void> loadOffers() async {
    state = state.copyWith(isLoading: true);

    try {
      final offers = await _service.getAllActiveOffers();
      state = state.copyWith(
        offers: offers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Recherche des offres
  Future<void> searchOffers(String searchTerm) async {
    state = state.copyWith(
      isLoading: true,
      searchTerm: searchTerm,
    );

    try {
      final offers = await _service.filterOffers(
        searchTerm: searchTerm.isEmpty ? null : searchTerm,
        type: state.selectedType,
        city: state.selectedCity,
        company: state.selectedCompany,
      );

      state = state.copyWith(
        offers: offers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Filtre par type d'offre
  Future<void> filterByType(JobOfferType? type) async {
    state = state.copyWith(
      isLoading: true,
      selectedType: type,
    );

    await _applyFilters();
  }

  /// Filtre par ville
  Future<void> filterByCity(String? city) async {
    state = state.copyWith(
      isLoading: true,
      selectedCity: city,
    );

    await _applyFilters();
  }

  /// Filtre par entreprise
  Future<void> filterByCompany(String? company) async {
    state = state.copyWith(
      isLoading: true,
      selectedCompany: company,
    );

    await _applyFilters();
  }

  /// Applique tous les filtres actuels
  Future<void> _applyFilters() async {
    try {
      final offers = await _service.filterOffers(
        searchTerm: state.searchTerm.isEmpty ? null : state.searchTerm,
        type: state.selectedType,
        city: state.selectedCity,
        company: state.selectedCompany,
      );

      state = state.copyWith(
        offers: offers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Remet à zéro tous les filtres
  Future<void> clearFilters() async {
    state = state.copyWith(
      isLoading: true,
      searchTerm: '',
    );

    await loadOffers();
  }

  /// Rafraîchit les données
  Future<void> refresh() async {
    await _applyFilters();
  }
}

/// État pour la gestion d'une offre spécifique (création/modification)
@immutable
class JobOfferFormState {
  const JobOfferFormState({
    required this.isLoading,
    required this.error,
    required this.isSuccess,
  });

  final bool isLoading;
  final String? error;
  final bool isSuccess;

  JobOfferFormState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return JobOfferFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  static const initial = JobOfferFormState(
    isLoading: false,
    error: null,
    isSuccess: false,
  );
}

/// Controller pour la gestion des formulaires d'offres
class JobOfferFormController extends StateNotifier<JobOfferFormState> {
  JobOfferFormController(this._ref) : super(JobOfferFormState.initial);

  final Ref _ref;

  JobOfferService get _service => _ref.read(jobOfferServiceProvider);

  /// Crée une nouvelle offre
  Future<void> createOffer(JobOffer offer) async {
    state = state.copyWith(isLoading: true, isSuccess: false);

    try {
      final id = await _service.createOffer(offer);
      if (id != null) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
        // Rafraîchir la liste des offres
        _ref.invalidate(allActiveJobOffersProvider);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Erreur lors de la création de l'offre",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Met à jour une offre existante
  Future<void> updateOffer(String id, JobOffer offer) async {
    state = state.copyWith(isLoading: true, isSuccess: false);

    try {
      final success = await _service.updateOffer(id, offer);
      if (success) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
        // Rafraîchir les données
        _ref.invalidate(allActiveJobOffersProvider);
        _ref.invalidate(jobOfferByIdProvider(id));
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Erreur lors de la mise à jour de l'offre",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Supprime une offre
  Future<void> deleteOffer(String id) async {
    state = state.copyWith(isLoading: true, isSuccess: false);

    try {
      final success = await _service.deleteOffer(id);
      if (success) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
        // Rafraîchir les données
        _ref.invalidate(allActiveJobOffersProvider);
        _ref.invalidate(currentUserJobOffersProvider);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Erreur lors de la suppression de l'offre",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Change le statut d'une offre
  Future<void> changeOfferStatus(String id, JobOfferStatus status) async {
    state = state.copyWith(isLoading: true, isSuccess: false);

    try {
      final success = await _service.changeOfferStatus(id, status);
      if (success) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
        // Rafraîchir les données
        _ref.invalidate(allActiveJobOffersProvider);
        _ref.invalidate(jobOfferByIdProvider(id));
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Erreur lors du changement de statut',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Remet à zéro l'état du formulaire
  void resetForm() {
    state = JobOfferFormState.initial;
  }
}

/// Providers pour les controllers

final jobOfferControllerProvider =
    StateNotifierProvider<JobOfferController, JobOffersState>((ref) {
  return JobOfferController(ref);
});

final jobOfferFormControllerProvider =
    StateNotifierProvider<JobOfferFormController, JobOfferFormState>((ref) {
  return JobOfferFormController(ref);
});
