import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Helper pour ajouter des données de test dans Firestore
class TestDataHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = 'userProfiles';

  /// Ajoute des profils alumni de test
  static Future<void> addTestAlumniProfiles() async {
    if (!kDebugMode) {
      print('⚠️ Ajout de données de test uniquement en mode debug');
      return;
    }

    try {
      print('🚀 Ajout de données de test...');

      final testProfiles = [
        {
          'firstName': 'Marie',
          'lastName': 'Dupont',
          'email': 'marie.dupont@example.com',
          'statut': 'Alumni',
          'entreprise': 'Google',
          'poste': 'Software Engineer',
          'ville': 'Paris',
          'anneePromotion': '2020',
          'bio': "Passionnée par le développement mobile et l'IA.",
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'firstName': 'Pierre',
          'lastName': 'Martin',
          'email': 'pierre.martin@example.com',
          'statut': 'Alumni',
          'entreprise': 'Microsoft',
          'poste': 'Product Manager',
          'ville': 'Lyon',
          'anneePromotion': '2019',
          'bio': 'Spécialisé dans les produits tech B2B.',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'firstName': 'Sophie',
          'lastName': 'Leroy',
          'email': 'sophie.leroy@example.com',
          'statut': 'Alumni',
          'entreprise': 'Amazon',
          'poste': 'UX Designer',
          'ville': 'Marseille',
          'anneePromotion': '2021',
          'bio': 'Design centré utilisateur et accessibilité.',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'firstName': 'Thomas',
          'lastName': 'Bernard',
          'email': 'thomas.bernard@example.com',
          'statut': 'Alumni',
          'entreprise': 'Startup Tech',
          'poste': 'CTO',
          'ville': 'Toulouse',
          'anneePromotion': '2018',
          'bio': 'Entrepreneur dans la fintech.',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'firstName': 'Emma',
          'lastName': 'Moreau',
          'email': 'emma.moreau@example.com',
          'statut': 'Alumni',
          'entreprise': 'Meta',
          'poste': 'Data Scientist',
          'ville': 'Paris',
          'anneePromotion': '2022',
          'bio': 'Machine learning et big data.',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'firstName': 'Lucas',
          'lastName': 'Petit',
          'email': 'lucas.petit@example.com',
          'statut': 'Étudiant',
          'entreprise': '',
          'poste': '',
          'ville': 'Bordeaux',
          'anneePromotion': '2024',
          'bio': 'Étudiant en dernière année.',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      final batch = _firestore.batch();

      for (final profile in testProfiles) {
        final docRef = _firestore.collection(_collectionPath).doc();
        batch.set(docRef, profile);
      }

      await batch.commit();

      print('✅ ${testProfiles.length} profils de test ajoutés avec succès !');
      print('📊 Répartition:');
      print(
          '   - ${testProfiles.where((p) => p['statut'] == 'Alumni').length} Alumni');
      print(
          '   - ${testProfiles.where((p) => p['statut'] == 'Étudiant').length} Étudiants');
    } catch (e) {
      print("❌ Erreur lors de l'ajout des données de test: $e");
      rethrow;
    }
  }

  /// Supprime tous les profils de test
  static Future<void> clearTestData() async {
    if (!kDebugMode) {
      print('⚠️ Suppression de données uniquement en mode debug');
      return;
    }

    try {
      print('🗑️ Suppression des données de test...');

      final querySnapshot = await _firestore.collection(_collectionPath).where(
        'email',
        whereIn: [
          'marie.dupont@example.com',
          'pierre.martin@example.com',
          'sophie.leroy@example.com',
          'thomas.bernard@example.com',
          'emma.moreau@example.com',
          'lucas.petit@example.com',
        ],
      ).get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('✅ ${querySnapshot.docs.length} profils de test supprimés');
    } catch (e) {
      print('❌ Erreur lors de la suppression des données de test: $e');
      rethrow;
    }
  }

  /// Vérifie si des données de test existent déjà
  static Future<bool> hasTestData() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('email', isEqualTo: 'marie.dupont@example.com')
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('❌ Erreur lors de la vérification des données de test: $e');
      return false;
    }
  }
}
