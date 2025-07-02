import 'package:ekod_alumni/src/features/jobs/jobs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JobOffer Model Tests', () {
    late JobOffer sampleJobOffer;
    late DateTime now;
    late DateTime futureDate;
    late DateTime pastDate;

    setUp(() {
      now = DateTime.now();
      futureDate = now.add(const Duration(days: 7));
      pastDate = now.subtract(const Duration(days: 1));

      sampleJobOffer = JobOffer(
        id: 'job_001',
        titre: 'Développeur Flutter Senior',
        description:
            'Nous recherchons un développeur Flutter expérimenté pour rejoindre notre équipe de développement mobile. Vous travaillerez sur des applications innovantes.',
        entreprise: 'TechCorp',
        ville: 'Paris',
        type: JobOfferType.emploi,
        datePublication: now,
        dateLimite: futureDate,
        publisherId: 'alumni_123',
        competencesRequises: ['Flutter', 'Dart', 'Firebase'],
        niveauEtude: 'Master',
        typeContrat: 'CDI',
        salaire: '45-55k€',
        contactEmail: 'rh@techcorp.com',
      );
    });

    group('Construction et sérialisation', () {
      test('devrait créer un JobOffer avec les valeurs requises', () {
        final jobOffer = JobOffer(
          id: 'test_id',
          titre: 'Test Job',
          description: 'Test description',
          entreprise: 'Test Company',
          ville: 'Test City',
          type: JobOfferType.stage,
          datePublication: now,
          dateLimite: futureDate,
          publisherId: 'publisher_123',
        );

        expect(jobOffer.id, 'test_id');
        expect(jobOffer.titre, 'Test Job');
        expect(jobOffer.type, JobOfferType.stage);
        expect(jobOffer.statut, JobOfferStatus.active); // valeur par défaut
        expect(jobOffer.competencesRequises, isEmpty); // valeur par défaut
      });

      test('devrait sérialiser vers/depuis JSON correctement', () {
        final json = sampleJobOffer.toJson();
        final reconstructed = JobOffer.fromJson(json);

        expect(reconstructed.id, sampleJobOffer.id);
        expect(reconstructed.titre, sampleJobOffer.titre);
        expect(reconstructed.description, sampleJobOffer.description);
        expect(reconstructed.type, sampleJobOffer.type);
        expect(
          reconstructed.competencesRequises,
          sampleJobOffer.competencesRequises,
        );
      });
    });

    group('Énumérations', () {
      test('JobOfferType devrait avoir les bonnes valeurs', () {
        expect(JobOfferType.stage.displayName, 'Stage');
        expect(JobOfferType.emploi.displayName, 'Emploi');
      });

      test('JobOfferStatus devrait avoir les bonnes valeurs', () {
        expect(JobOfferStatus.active.displayName, 'Active');
        expect(JobOfferStatus.fermee.displayName, 'Fermée');
        expect(JobOfferStatus.pourvue.displayName, 'Pourvue');
      });
    });

    group('Getters de statut', () {
      test(
          'isActive devrait retourner true pour une offre active et non expirée',
          () {
        expect(sampleJobOffer.isActive, isTrue);
      });

      test('isActive devrait retourner false pour une offre fermée', () {
        final closedOffer =
            sampleJobOffer.copyWith(statut: JobOfferStatus.fermee);
        expect(closedOffer.isActive, isFalse);
      });

      test('isActive devrait retourner false pour une offre expirée', () {
        final expiredOffer = sampleJobOffer.copyWith(dateLimite: pastDate);
        expect(expiredOffer.isActive, isFalse);
      });

      test('isExpired devrait retourner true pour une date limite passée', () {
        final expiredOffer = sampleJobOffer.copyWith(dateLimite: pastDate);
        expect(expiredOffer.isExpired, isTrue);
      });

      test('isExpired devrait retourner false pour une date limite future', () {
        expect(sampleJobOffer.isExpired, isFalse);
      });
    });

    group('Getters de date limite', () {
      test('daysUntilDeadline devrait calculer les jours restants correctement',
          () {
        // Le nombre peut varier légèrement selon le timing, vérifions qu'il est proche de 7
        expect(sampleJobOffer.daysUntilDeadline, inInclusiveRange(6, 7));
      });

      test('daysUntilDeadline devrait retourner 0 pour une offre expirée', () {
        final expiredOffer = sampleJobOffer.copyWith(dateLimite: pastDate);
        expect(expiredOffer.daysUntilDeadline, 0);
      });

      test('deadlineText devrait afficher le texte correct', () {
        // Test pour demain
        final tomorrowOffer = sampleJobOffer.copyWith(
          dateLimite: now.add(const Duration(days: 1, hours: 12)),
        );
        expect(tomorrowOffer.deadlineText, 'Expire demain');

        // Test pour aujourd'hui (même jour)
        final todayOffer = sampleJobOffer.copyWith(
          dateLimite: now.add(const Duration(hours: 2)),
        );
        expect(todayOffer.deadlineText, "Expire aujourd'hui");

        // Test pour une offre expirée
        final expiredOffer = sampleJobOffer.copyWith(dateLimite: pastDate);
        expect(expiredOffer.deadlineText, 'Expirée');

        // Test pour plusieurs jours (vérifier format général)
        final multiDayOffer = sampleJobOffer.copyWith(
          dateLimite: now.add(const Duration(days: 5)),
        );
        expect(multiDayOffer.deadlineText.contains('Expire dans'), isTrue);
        expect(multiDayOffer.deadlineText.contains('jours'), isTrue);
      });
    });

    group("Getters d'affichage", () {
      test('typeIcon devrait retourner la bonne icône', () {
        expect(sampleJobOffer.typeIcon, '💼');

        final stageOffer = sampleJobOffer.copyWith(type: JobOfferType.stage);
        expect(stageOffer.typeIcon, '🎓');
      });

      test('statusColor devrait retourner la bonne couleur', () {
        expect(sampleJobOffer.statusColor, '#4CAF50');

        final closedOffer =
            sampleJobOffer.copyWith(statut: JobOfferStatus.fermee);
        expect(closedOffer.statusColor, '#757575');

        final filledOffer =
            sampleJobOffer.copyWith(statut: JobOfferStatus.pourvue);
        expect(filledOffer.statusColor, '#2196F3');
      });

      test('shortDescription devrait tronquer les descriptions longues', () {
        final longDescription = 'A' * 200;
        final longOffer = sampleJobOffer.copyWith(description: longDescription);

        expect(longOffer.shortDescription.length, 150);
        expect(longOffer.shortDescription.endsWith('...'), isTrue);
      });

      test(
          'shortDescription devrait retourner la description complète si courte',
          () {
        const shortDescription = 'Description courte';
        final shortOffer =
            sampleJobOffer.copyWith(description: shortDescription);

        expect(shortOffer.shortDescription, shortDescription);
      });

      test('competencesText devrait formater les compétences', () {
        expect(sampleJobOffer.competencesText, 'Flutter, Dart, Firebase');

        final noSkillsOffer = sampleJobOffer.copyWith(competencesRequises: []);
        expect(noSkillsOffer.competencesText, 'Aucune compétence spécifiée');
      });
    });

    group('CopyWith et immutabilité', () {
      test('copyWith devrait créer une nouvelle instance avec les changements',
          () {
        final updated = sampleJobOffer.copyWith(
          titre: 'Nouveau titre',
          salaire: '50-60k€',
        );

        expect(updated.titre, 'Nouveau titre');
        expect(updated.salaire, '50-60k€');
        expect(updated.entreprise, sampleJobOffer.entreprise); // inchangé
        expect(updated.id, sampleJobOffer.id); // inchangé
      });

      test('les instances doivent être immutables', () {
        final copy = JobOffer.fromJson(sampleJobOffer.toJson());
        expect(copy, equals(sampleJobOffer));
        expect(copy.hashCode, equals(sampleJobOffer.hashCode));
      });
    });
  });
}
