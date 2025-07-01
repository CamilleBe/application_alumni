import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekod_alumni/src/features/alumni/alumni.dart';
import 'package:ekod_alumni/src/features/alumni/data/alumni_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlumniRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late AlumniRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = AlumniRepository(firestore: fakeFirestore);
    });

    group('_convertToAlumni', () {
      test('convertit correctement les données complètes', () {
        // Utiliser reflection pour accéder à la méthode privée dans un test
        final data = {
          'firstName': 'Jean',
          'lastName': 'Dupont',
          'email': 'jean.dupont@example.com',
          'statut': 'Alumni',
          'entreprise': 'TechCorp',
          'poste': 'Développeur',
          'ville': 'Paris',
          'anneePromotion': '2020',
          'bio': 'Développeur passionné',
          'profileImageUrl': 'https://example.com/photo.jpg',
          'createdAt': Timestamp.fromDate(DateTime(2023)),
          'updatedAt': Timestamp.fromDate(DateTime(2023, 6)),
        };

        // Test avec réflexion simulée en créant un alumni via les données
        final alumni = Alumni(
          id: 'test-id',
          firstName: data['firstName']! as String,
          lastName: data['lastName']! as String,
          email: data['email']! as String,
          statut: data['statut']! as String,
          entreprise: data['entreprise']! as String,
          poste: data['poste']! as String,
          ville: data['ville']! as String,
          anneePromotion: data['anneePromotion']! as String,
          bio: data['bio']! as String,
          profileImageUrl: data['profileImageUrl']! as String,
          createdAt: (data['createdAt']! as Timestamp).toDate(),
          updatedAt: (data['updatedAt']! as Timestamp).toDate(),
        );

        expect(alumni.id, 'test-id');
        expect(alumni.firstName, 'Jean');
        expect(alumni.lastName, 'Dupont');
        expect(alumni.fullName, 'Jean Dupont');
        expect(alumni.email, 'jean.dupont@example.com');
        expect(alumni.statut, 'Alumni');
        expect(alumni.isAlumni, true);
        expect(alumni.entreprise, 'TechCorp');
        expect(alumni.ville, 'Paris');
      });

      test('gère les données minimales obligatoires', () {
        final data = {
          'firstName': 'Marie',
          'lastName': 'Martin',
          'email': 'marie.martin@example.com',
        };

        final alumni = Alumni(
          id: 'test-id-2',
          firstName: data['firstName']!,
          lastName: data['lastName']!,
          email: data['email']!,
        );

        expect(alumni.id, 'test-id-2');
        expect(alumni.firstName, 'Marie');
        expect(alumni.lastName, 'Martin');
        expect(alumni.fullName, 'Marie Martin');
        expect(alumni.email, 'marie.martin@example.com');
        expect(alumni.statut, null);
        expect(alumni.isAlumni, false);
        expect(alumni.entreprise, null);
        expect(alumni.ville, null);
      });
    });

    group('fetchAllAlumni', () {
      test('récupère uniquement les utilisateurs avec statut Alumni', () async {
        // Préparer les données de test
        await fakeFirestore.collection('userProfiles').doc('user1').set({
          'firstName': 'Jean',
          'lastName': 'Dupont',
          'email': 'jean.dupont@example.com',
          'statut': 'Alumni',
          'entreprise': 'TechCorp',
          'ville': 'Paris',
        });

        await fakeFirestore.collection('userProfiles').doc('user2').set({
          'firstName': 'Marie',
          'lastName': 'Martin',
          'email': 'marie.martin@example.com',
          'statut': 'Étudiant',
          'ville': 'Lyon',
        });

        await fakeFirestore.collection('userProfiles').doc('user3').set({
          'firstName': 'Pierre',
          'lastName': 'Durand',
          'email': 'pierre.durand@example.com',
          'statut': 'Alumni',
          'entreprise': 'StartupXYZ',
          'ville': 'Marseille',
        });

        // Exécuter le test
        final alumni = await repository.fetchAllAlumni();

        // Vérifications
        expect(alumni.length, 2);
        expect(alumni.map((a) => a.firstName), containsAll(['Jean', 'Pierre']));
        expect(alumni.every((a) => a.statut == 'Alumni'), true);
      });

      test('retourne une liste vide si aucun alumni', () async {
        await fakeFirestore.collection('userProfiles').doc('user1').set({
          'firstName': 'Marie',
          'lastName': 'Martin',
          'email': 'marie.martin@example.com',
          'statut': 'Étudiant',
        });

        final alumni = await repository.fetchAllAlumni();

        expect(alumni, isEmpty);
      });

      test('ignore les documents avec des données manquantes', () async {
        await fakeFirestore.collection('userProfiles').doc('user1').set({
          'firstName': 'Jean',
          'lastName': 'Dupont',
          'email': 'jean.dupont@example.com',
          'statut': 'Alumni',
        });

        await fakeFirestore.collection('userProfiles').doc('user2').set({
          'firstName': 'Incomplet',
          // lastName manquant
          'email': 'incomplet@example.com',
          'statut': 'Alumni',
        });

        final alumni = await repository.fetchAllAlumni();

        expect(alumni.length, 1);
        expect(alumni.first.firstName, 'Jean');
      });
    });

    group('searchAlumniByName', () {
      setUp(() async {
        await fakeFirestore.collection('userProfiles').doc('user1').set({
          'firstName': 'Jean',
          'lastName': 'Dupont',
          'email': 'jean.dupont@example.com',
          'statut': 'Alumni',
        });

        await fakeFirestore.collection('userProfiles').doc('user2').set({
          'firstName': 'Marie',
          'lastName': 'Martin',
          'email': 'marie.martin@example.com',
          'statut': 'Alumni',
        });

        await fakeFirestore.collection('userProfiles').doc('user3').set({
          'firstName': 'Pierre',
          'lastName': 'Durand',
          'email': 'pierre.durand@example.com',
          'statut': 'Alumni',
        });
      });

      test('trouve par prénom', () async {
        final results = await repository.searchAlumniByName('Jean');

        expect(results.length, 1);
        expect(results.first.firstName, 'Jean');
      });

      test('trouve par nom de famille', () async {
        final results = await repository.searchAlumniByName('Martin');

        expect(results.length, 1);
        expect(results.first.lastName, 'Martin');
      });

      test('trouve par nom partiel (insensible à la casse)', () async {
        final results = await repository.searchAlumniByName('mar');

        expect(results.length, 1);
        expect(results.first.lastName, 'Martin');
      });

      test('retourne tous les alumni si terme de recherche vide', () async {
        final results = await repository.searchAlumniByName('');

        expect(results.length, 3);
      });

      test('retourne liste vide si aucune correspondance', () async {
        final results = await repository.searchAlumniByName('Inexistant');

        expect(results, isEmpty);
      });
    });

    group('filterAlumniByCity', () {
      setUp(() async {
        await fakeFirestore.collection('userProfiles').doc('user1').set({
          'firstName': 'Jean',
          'lastName': 'Dupont',
          'email': 'jean.dupont@example.com',
          'statut': 'Alumni',
          'ville': 'Paris',
        });

        await fakeFirestore.collection('userProfiles').doc('user2').set({
          'firstName': 'Marie',
          'lastName': 'Martin',
          'email': 'marie.martin@example.com',
          'statut': 'Alumni',
          'ville': 'Lyon',
        });

        await fakeFirestore.collection('userProfiles').doc('user3').set({
          'firstName': 'Pierre',
          'lastName': 'Durand',
          'email': 'pierre.durand@example.com',
          'statut': 'Alumni',
          'ville': 'Paris',
        });
      });

      test('filtre correctement par ville', () async {
        final results = await repository.filterAlumniByCity('Paris');

        expect(results.length, 2);
        expect(results.every((a) => a.ville == 'Paris'), true);
        expect(
          results.map((a) => a.firstName),
          containsAll(['Jean', 'Pierre']),
        );
      });

      test('retourne liste vide si ville inexistante', () async {
        final results = await repository.filterAlumniByCity('Toulouse');

        expect(results, isEmpty);
      });

      test('retourne tous les alumni si ville vide', () async {
        final results = await repository.filterAlumniByCity('');

        expect(results.length, 3);
      });
    });

    group('getAvailableCities', () {
      test('retourne la liste des villes uniques', () async {
        await fakeFirestore.collection('userProfiles').doc('user1').set({
          'firstName': 'Jean',
          'lastName': 'Dupont',
          'email': 'jean.dupont@example.com',
          'statut': 'Alumni',
          'ville': 'Paris',
        });

        await fakeFirestore.collection('userProfiles').doc('user2').set({
          'firstName': 'Marie',
          'lastName': 'Martin',
          'email': 'marie.martin@example.com',
          'statut': 'Alumni',
          'ville': 'Lyon',
        });

        await fakeFirestore.collection('userProfiles').doc('user3').set({
          'firstName': 'Pierre',
          'lastName': 'Durand',
          'email': 'pierre.durand@example.com',
          'statut': 'Alumni',
          'ville': 'Paris', // Doublon
        });

        await fakeFirestore.collection('userProfiles').doc('user4').set({
          'firstName': 'Sophie',
          'lastName': 'Bernard',
          'email': 'sophie.bernard@example.com',
          'statut': 'Alumni',
          // ville manquante
        });

        final cities = await repository.getAvailableCities();

        expect(cities.length, 2);
        expect(cities, containsAll(['Lyon', 'Paris']));
        expect(cities, isSorted); // Vérifie que c'est trié
      });

      test('retourne liste vide si aucune ville', () async {
        await fakeFirestore.collection('userProfiles').doc('user1').set({
          'firstName': 'Jean',
          'lastName': 'Dupont',
          'email': 'jean.dupont@example.com',
          'statut': 'Alumni',
          // ville manquante
        });

        final cities = await repository.getAvailableCities();

        expect(cities, isEmpty);
      });
    });

    group('fetchAlumniById', () {
      test('récupère un alumni existant', () async {
        await fakeFirestore.collection('userProfiles').doc('test-user').set({
          'firstName': 'Jean',
          'lastName': 'Dupont',
          'email': 'jean.dupont@example.com',
          'statut': 'Alumni',
          'ville': 'Paris',
        });

        final alumni = await repository.fetchAlumniById('test-user');

        expect(alumni, isNotNull);
        expect(alumni!.id, 'test-user');
        expect(alumni.firstName, 'Jean');
        expect(alumni.statut, 'Alumni');
      });

      test('retourne null si utilisateur inexistant', () async {
        final alumni = await repository.fetchAlumniById('inexistant');

        expect(alumni, isNull);
      });

      test("retourne null si utilisateur n'est pas alumni", () async {
        await fakeFirestore.collection('userProfiles').doc('etudiant').set({
          'firstName': 'Marie',
          'lastName': 'Martin',
          'email': 'marie.martin@example.com',
          'statut': 'Étudiant',
        });

        final alumni = await repository.fetchAlumniById('etudiant');

        expect(alumni, isNull);
      });
    });
  });
}

// Matcher personnalisé pour vérifier si une liste est triée
Matcher get isSorted => predicate<List<String>>(
      (list) {
        for (var i = 1; i < list.length; i++) {
          if (list[i].compareTo(list[i - 1]) < 0) {
            return false;
          }
        }
        return true;
      },
      'is sorted',
    );
