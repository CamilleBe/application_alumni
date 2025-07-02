import 'package:ekod_alumni/src/features/jobs/jobs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('JobOfferService Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('JobOfferService devrait être créé correctement', () {
      final service = container.read(jobOfferServiceProvider);
      expect(service, isA<JobOfferService>());
    });

    test('getAllActiveOffers devrait retourner des offres', () async {
      final service = container.read(jobOfferServiceProvider);
      final offers = await service.getAllActiveOffers();

      expect(offers, isNotEmpty);
      expect(offers.length, greaterThan(0));

      // Vérifier que toutes les offres sont actives
      for (final offer in offers) {
        expect(offer.isActive, isTrue);
      }
    });

    test('searchOffers devrait filtrer par terme de recherche', () async {
      final service = container.read(jobOfferServiceProvider);

      // Recherche avec un terme spécifique
      final flutterOffers = await service.searchOffers('Flutter');
      expect(flutterOffers, isNotEmpty);

      // Vérifier que le terme apparaît dans les résultats
      final hasFlutterInTitle = flutterOffers.any(
        (offer) => offer.titre.toLowerCase().contains('flutter'),
      );
      expect(hasFlutterInTitle, isTrue);
    });

    test('getOfferById devrait retourner une offre spécifique', () async {
      final service = container.read(jobOfferServiceProvider);

      // Récupérer d'abord toutes les offres pour avoir un ID valide
      final allOffers = await service.getAllActiveOffers();
      expect(allOffers, isNotEmpty);

      final firstOfferId = allOffers.first.id;
      final specificOffer = await service.getOfferById(firstOfferId);

      expect(specificOffer, isNotNull);
      expect(specificOffer!.id, equals(firstOfferId));
    });

    test('filterOffers devrait filtrer par type', () async {
      final service = container.read(jobOfferServiceProvider);

      // Filtrer par type "stage"
      final stageOffers = await service.filterOffers(type: JobOfferType.stage);
      expect(stageOffers, isNotEmpty);

      // Vérifier que tous les résultats sont des stages
      for (final offer in stageOffers) {
        expect(offer.type, equals(JobOfferType.stage));
      }

      // Filtrer par type "emploi"
      final jobOffers = await service.filterOffers(type: JobOfferType.emploi);
      expect(jobOffers, isNotEmpty);

      // Vérifier que tous les résultats sont des emplois
      for (final offer in jobOffers) {
        expect(offer.type, equals(JobOfferType.emploi));
      }
    });

    test('getAvailableCities devrait retourner une liste de villes', () async {
      final service = container.read(jobOfferServiceProvider);
      final cities = await service.getAvailableCities();

      expect(cities, isNotEmpty);
      expect(cities, contains('Paris'));
      expect(cities, contains('Lyon'));

      // Vérifier que la liste est triée
      final sortedCities = List<String>.from(cities)..sort();
      expect(cities, equals(sortedCities));
    });

    test("getAvailableCompanies devrait retourner une liste d'entreprises",
        () async {
      final service = container.read(jobOfferServiceProvider);
      final companies = await service.getAvailableCompanies();

      expect(companies, isNotEmpty);
      expect(companies, contains('TechFlow Solutions'));

      // Vérifier que la liste est triée
      final sortedCompanies = List<String>.from(companies)..sort();
      expect(companies, equals(sortedCompanies));
    });

    test('getPopularSkills devrait retourner des compétences', () async {
      final service = container.read(jobOfferServiceProvider);
      final skills = await service.getPopularSkills();

      expect(skills, isNotEmpty);
      expect(skills.length, lessThanOrEqualTo(10)); // Max 10 compétences
      expect(skills, contains('Flutter'));
    });

    test('getOffersStats devrait retourner des statistiques', () async {
      final service = container.read(jobOfferServiceProvider);
      final stats = await service.getOffersStats();

      expect(stats, isNotEmpty);
      expect(stats.containsKey('total'), isTrue);
      expect(stats.containsKey('active'), isTrue);
      expect(stats.containsKey('stages'), isTrue);
      expect(stats.containsKey('emplois'), isTrue);

      expect(stats['total'], greaterThan(0));
      expect(stats['active'], greaterThan(0));
    });
  });

  group('Providers Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('allActiveJobOffersProvider devrait fonctionner', () async {
      final asyncValue =
          await container.read(allActiveJobOffersProvider.future);

      expect(asyncValue, isA<List<JobOffer>>());
      expect(asyncValue, isNotEmpty);
    });

    test('availableCitiesProvider devrait fonctionner', () async {
      final cities = await container.read(availableCitiesProvider.future);

      expect(cities, isA<List<String>>());
      expect(cities, isNotEmpty);
    });

    test('availableCompaniesProvider devrait fonctionner', () async {
      final companies = await container.read(availableCompaniesProvider.future);

      expect(companies, isA<List<String>>());
      expect(companies, isNotEmpty);
    });

    test('jobOffersStatsProvider devrait fonctionner', () async {
      final stats = await container.read(jobOffersStatsProvider.future);

      expect(stats, isA<Map<String, int>>());
      expect(stats, isNotEmpty);
    });

    test('jobOfferByIdProvider devrait fonctionner avec un ID valide',
        () async {
      // D'abord récupérer toutes les offres pour avoir un ID valide
      final allOffers = await container.read(allActiveJobOffersProvider.future);
      expect(allOffers, isNotEmpty);

      final firstOfferId = allOffers.first.id;
      final offer =
          await container.read(jobOfferByIdProvider(firstOfferId).future);

      expect(offer, isNotNull);
      expect(offer!.id, equals(firstOfferId));
    });

    test('jobOfferByIdProvider devrait retourner null pour un ID invalide',
        () async {
      const invalidId = 'invalid_id_123';
      final offer =
          await container.read(jobOfferByIdProvider(invalidId).future);

      expect(offer, isNull);
    });
  });

  group('JobOfferController Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test("JobOfferController devrait se créer avec l'état initial", () {
      final controller = container.read(jobOfferControllerProvider.notifier);
      final state = container.read(jobOfferControllerProvider);

      expect(controller, isA<JobOfferController>());
      expect(state, isA<JobOffersState>());
    });

    test("JobOfferFormController devrait se créer avec l'état initial", () {
      final controller =
          container.read(jobOfferFormControllerProvider.notifier);
      final state = container.read(jobOfferFormControllerProvider);

      expect(controller, isA<JobOfferFormController>());
      expect(state, isA<JobOfferFormState>());
      expect(state, equals(JobOfferFormState.initial));
    });
  });
}
