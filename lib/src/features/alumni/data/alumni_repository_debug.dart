import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Repository de debug pour tester les requêtes Firebase
class AlumniRepositoryDebug {
  AlumniRepositoryDebug({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'userProfiles';

  /// Test 1: Récupérer tous les documents userProfiles
  Future<Map<String, dynamic>> testFetchAllUserProfiles() async {
    try {
      if (kDebugMode) {
        print('🔍 Test 1: Récupération de tous les userProfiles...');
      }

      final querySnapshot = await _firestore.collection(_collectionPath).get();

      final docs = querySnapshot.docs;

      if (kDebugMode) {
        print('✅ Trouvé ${docs.length} documents');
        for (final doc in docs) {
          print('📄 Document ${doc.id}: ${doc.data()}');
        }
      }

      return {
        'success': true,
        'count': docs.length,
        'documents': docs
            .map(
              (doc) => {
                'id': doc.id,
                'data': doc.data(),
              },
            )
            .toList(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur Test 1: $e');
      }
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Test 2: Récupérer seulement les alumni
  Future<Map<String, dynamic>> testFetchAlumniOnly() async {
    try {
      if (kDebugMode) {
        print('🔍 Test 2: Récupération des alumni seulement...');
      }

      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('statut', isEqualTo: 'Alumni')
          .get();

      final docs = querySnapshot.docs;

      if (kDebugMode) {
        print('✅ Trouvé ${docs.length} alumni');
        for (final doc in docs) {
          final data = doc.data();
          print(
              '📄 Alumni ${doc.id}: ${data['firstName']} ${data['lastName']} - ${data['statut']}');
        }
      }

      return {
        'success': true,
        'count': docs.length,
        'alumni': docs
            .map(
              (doc) => {
                'id': doc.id,
                'data': doc.data(),
              },
            )
            .toList(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur Test 2: $e');
      }
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Test 3: Récupérer les villes uniques
  Future<Map<String, dynamic>> testGetAvailableCities() async {
    try {
      if (kDebugMode) {
        print('🔍 Test 3: Récupération des villes...');
      }

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

      if (kDebugMode) {
        print('✅ Trouvé ${cityList.length} villes: $cityList');
      }

      return {
        'success': true,
        'cities': cityList,
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur Test 3: $e');
      }
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Test 4: Récupérer les entreprises uniques
  Future<Map<String, dynamic>> testGetAvailableCompanies() async {
    try {
      if (kDebugMode) {
        print('🔍 Test 4: Récupération des entreprises...');
      }

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

      if (kDebugMode) {
        print('✅ Trouvé ${companyList.length} entreprises: $companyList');
      }

      return {
        'success': true,
        'companies': companyList,
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur Test 4: $e');
      }
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Test 5: Récupérer les années de promotion uniques
  Future<Map<String, dynamic>> testGetAvailableYears() async {
    try {
      if (kDebugMode) {
        print('🔍 Test 5: Récupération des années...');
      }

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

      final yearList = years.toList()..sort((a, b) => b.compareTo(a));

      if (kDebugMode) {
        print('✅ Trouvé ${yearList.length} années: $yearList');
      }

      return {
        'success': true,
        'years': yearList,
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur Test 5: $e');
      }
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Lance tous les tests
  Future<Map<String, dynamic>> runAllTests() async {
    if (kDebugMode) {
      print('🚀 Début des tests Firebase...');
    }

    final results = <String, dynamic>{};

    results['test1'] = await testFetchAllUserProfiles();
    results['test2'] = await testFetchAlumniOnly();
    results['test3'] = await testGetAvailableCities();
    results['test4'] = await testGetAvailableCompanies();
    results['test5'] = await testGetAvailableYears();

    final failedTests = results.entries
        .where((entry) => entry.value['success'] != true)
        .map((entry) => entry.key)
        .toList();

    if (kDebugMode) {
      if (failedTests.isEmpty) {
        print('🎉 Tous les tests sont passés !');
      } else {
        print('❌ Tests échoués: $failedTests');
      }
    }

    return {
      'allTestsPassed': failedTests.isEmpty,
      'failedTests': failedTests,
      'results': results,
    };
  }
}

// Provider pour les tests
final alumniDebugRepositoryProvider = Provider<AlumniRepositoryDebug>((ref) {
  return AlumniRepositoryDebug(
    firestore: FirebaseFirestore.instance,
  );
});

// Provider pour lancer tous les tests
final alumniDebugTestsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(alumniDebugRepositoryProvider).runAllTests();
});
