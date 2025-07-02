import 'package:ekod_alumni/src/features/jobs/domain/job_offer.dart';

/// Helper pour générer des données de test réalistes pour les offres d'emploi
class JobOfferTestData {
  /// Liste d'offres d'emploi de test
  static List<JobOffer> get sampleJobOffers => [
        // Offres d'emploi
        JobOffer(
          id: 'job_001',
          titre: 'Développeur Flutter Senior',
          description: '''
Nous recherchons un développeur Flutter expérimenté pour rejoindre notre équipe produit dynamique.

Missions principales :
• Développer et maintenir notre application mobile Flutter
• Collaborer avec l'équipe UI/UX pour implémenter de nouvelles fonctionnalités
• Optimiser les performances et l'expérience utilisateur
• Participer aux revues de code et mentorer les développeurs junior

Profil recherché :
• 3+ années d'expérience en développement Flutter
• Maîtrise de Dart, Firebase, et des architectures modernes
• Expérience avec les tests unitaires et d'intégration
• Bon niveau d'anglais (équipe internationale)
          ''',
          entreprise: 'TechFlow Solutions',
          ville: 'Paris',
          type: JobOfferType.emploi,
          datePublication: DateTime.now().subtract(const Duration(days: 2)),
          dateLimite: DateTime.now().add(const Duration(days: 25)),
          publisherId: 'alumni_001',
          competencesRequises: [
            'Flutter',
            'Dart',
            'Firebase',
            'Git',
            'REST API'
          ],
          niveauEtude: 'Bac+5',
          typeContrat: 'CDI',
          salaire: '55k - 65k € selon expérience',
          urlEntreprise: 'https://techflow-solutions.com',
          contactEmail: 'recrutement@techflow-solutions.com',
          contactTelephone: '+33 1 42 86 75 30',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),

        JobOffer(
          id: 'job_002',
          titre: 'Chef de Projet Digital',
          description: '''
Rejoignez notre agence digitale en pleine croissance en tant que Chef de Projet Digital !

Vous serez responsable de :
• Gérer des projets web et mobile de A à Z
• Coordonner les équipes techniques, créatives et commerciales
• Assurer la relation client et le suivi budgétaire
• Proposer des solutions innovantes adaptées aux besoins clients

Nous recherchons :
• 2-4 ans d'expérience en gestion de projet digital
• Maîtrise des méthodologies Agile/Scrum
• Excellentes capacités de communication
• Esprit d'équipe et leadership naturel
          ''',
          entreprise: 'Digital Factory',
          ville: 'Lyon',
          type: JobOfferType.emploi,
          datePublication: DateTime.now().subtract(const Duration(days: 5)),
          dateLimite: DateTime.now().add(const Duration(days: 20)),
          publisherId: 'alumni_002',
          competencesRequises: [
            'Gestion de projet',
            'Agile',
            'Scrum',
            'Communication'
          ],
          niveauEtude: 'Bac+3/5',
          typeContrat: 'CDI',
          salaire: '42k - 50k €',
          urlEntreprise: 'https://digital-factory.fr',
          contactEmail: 'rh@digital-factory.fr',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),

        // Offres de stage
        JobOffer(
          id: 'stage_001',
          titre: 'Stage Développement Web - React/Node.js',
          description: '''
Stage de 6 mois dans une startup innovante spécialisée dans l'IoT.

Au programme :
• Développement d'interfaces utilisateur avec React
• Création d'APIs avec Node.js et Express
• Participation à la conception de nouvelles fonctionnalités
• Travail en équipe agile avec des développeurs seniors

Ce que nous offrons :
• Encadrement par des développeurs expérimentés
• Formation aux technologies modernes
• Environnement de travail stimulant
• Possibilité d'embauche à l'issue du stage
          ''',
          entreprise: 'IoT Innovations',
          ville: 'Toulouse',
          type: JobOfferType.stage,
          datePublication: DateTime.now().subtract(const Duration(days: 1)),
          dateLimite: DateTime.now().add(const Duration(days: 30)),
          publisherId: 'alumni_003',
          competencesRequises: ['React', 'Node.js', 'JavaScript', 'Git'],
          niveauEtude: 'Bac+3/4/5',
          typeContrat: 'Stage 6 mois',
          salaire: '1200€/mois',
          urlEntreprise: 'https://iot-innovations.com',
          contactEmail: 'stages@iot-innovations.com',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),

        JobOffer(
          id: 'stage_002',
          titre: 'Stage Marketing Digital & Communication',
          description: '''
Rejoignez notre équipe marketing pour un stage de 4-6 mois !

Missions :
• Gestion des réseaux sociaux (LinkedIn, Instagram, Twitter)
• Création de contenus visuels et rédactionnels
• Analyse des performances et reporting
• Participation aux campagnes publicitaires
• Support événementiel

Profil recherché :
• Étudiant en marketing, communication ou école de commerce
• Créativité et excellent relationnel
• Maîtrise des outils Adobe (Photoshop, Illustrator)
• Première expérience en marketing digital appréciée
          ''',
          entreprise: 'GreenTech Startup',
          ville: 'Nantes',
          type: JobOfferType.stage,
          datePublication: DateTime.now().subtract(const Duration(days: 3)),
          dateLimite: DateTime.now().add(const Duration(days: 22)),
          publisherId: 'alumni_004',
          competencesRequises: [
            'Marketing digital',
            'Réseaux sociaux',
            'Adobe Creative',
            'Communication'
          ],
          niveauEtude: 'Bac+3/4/5',
          typeContrat: 'Stage 4-6 mois',
          salaire: '800€/mois',
          urlEntreprise: 'https://greentech-startup.fr',
          contactEmail: 'marketing@greentech-startup.fr',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),

        JobOffer(
          id: 'job_003',
          titre: 'Ingénieur DevOps',
          description: '''
Nous recherchons un Ingénieur DevOps pour accompagner notre croissance.

Responsabilités :
• Automatisation des déploiements et CI/CD
• Gestion de l'infrastructure cloud (AWS/Azure)
• Monitoring et optimisation des performances
• Sécurisation des environnements
• Support aux équipes de développement

Technologies utilisées :
• Docker, Kubernetes, Terraform
• Jenkins, GitLab CI
• AWS/Azure, Ansible
• Prometheus, Grafana
          ''',
          entreprise: 'CloudCorp',
          ville: 'Bordeaux',
          type: JobOfferType.emploi,
          datePublication: DateTime.now().subtract(const Duration(days: 7)),
          dateLimite: DateTime.now().add(const Duration(days: 15)),
          publisherId: 'alumni_005',
          competencesRequises: [
            'DevOps',
            'Docker',
            'Kubernetes',
            'AWS',
            'CI/CD'
          ],
          niveauEtude: 'Bac+5',
          typeContrat: 'CDI',
          salaire: '50k - 60k €',
          urlEntreprise: 'https://cloudcorp.io',
          contactEmail: 'jobs@cloudcorp.io',
          contactTelephone: '+33 5 56 78 90 12',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),

        // Offre fermée (pour tester les différents statuts)
        JobOffer(
          id: 'job_004',
          titre: 'UX/UI Designer',
          description: '''
Designer UX/UI pour une application de e-commerce innovante.

Missions :
• Conception d'interfaces utilisateur intuitives
• Recherche utilisateur et tests d'usabilité
• Création de prototypes interactifs
• Collaboration avec les équipes produit et tech
          ''',
          entreprise: 'E-Shop Plus',
          ville: 'Lille',
          type: JobOfferType.emploi,
          datePublication: DateTime.now().subtract(const Duration(days: 15)),
          dateLimite:
              DateTime.now().subtract(const Duration(days: 2)), // Expirée
          publisherId: 'alumni_006',
          statut: JobOfferStatus.fermee,
          competencesRequises: ['UX Design', 'UI Design', 'Figma', 'Prototype'],
          niveauEtude: 'Bac+3/5',
          typeContrat: 'CDI',
          salaire: '38k - 45k €',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),

        JobOffer(
          id: 'stage_003',
          titre: 'Stage Data Science & IA',
          description: '''
Stage de fin d'études en Data Science dans une entreprise leader de la tech.

Projet :
• Développement d'algorithmes de machine learning
• Analyse de données massives avec Python
• Visualisation et présentation des résultats
• Intégration des modèles en production

Compétences requises :
• Python (Pandas, Scikit-learn, TensorFlow)
• Statistiques et mathématiques appliquées
• SQL et bases de données
• Curiosité et esprit analytique
          ''',
          entreprise: 'DataMind AI',
          ville: 'Paris',
          type: JobOfferType.stage,
          datePublication: DateTime.now().subtract(const Duration(hours: 12)),
          dateLimite: DateTime.now().add(const Duration(days: 35)),
          publisherId: 'alumni_007',
          competencesRequises: [
            'Python',
            'Machine Learning',
            'Data Science',
            'SQL',
            'TensorFlow'
          ],
          niveauEtude: 'Bac+5',
          typeContrat: 'Stage 6 mois',
          salaire: '1400€/mois',
          urlEntreprise: 'https://datamind-ai.com',
          contactEmail: 'stages@datamind-ai.com',
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
      ];

  /// Récupère les offres actives uniquement
  static List<JobOffer> get activeJobOffers =>
      sampleJobOffers.where((offer) => offer.isActive).toList();

  /// Récupère les offres de stage uniquement
  static List<JobOffer> get internshipOffers => sampleJobOffers
      .where((offer) => offer.type == JobOfferType.stage)
      .toList();

  /// Récupère les offres d'emploi uniquement
  static List<JobOffer> get jobOffers => sampleJobOffers
      .where((offer) => offer.type == JobOfferType.emploi)
      .toList();

  /// Récupère les offres par ville
  static List<JobOffer> getOffersByCity(String city) =>
      sampleJobOffers.where((offer) => offer.ville == city).toList();

  /// Récupère les offres par entreprise
  static List<JobOffer> getOffersByCompany(String company) =>
      sampleJobOffers.where((offer) => offer.entreprise == company).toList();

  /// Récupère une offre par son ID
  static JobOffer? getOfferById(String id) {
    try {
      return sampleJobOffers.firstWhere((offer) => offer.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Liste des villes disponibles
  static List<String> get availableCities =>
      sampleJobOffers.map((offer) => offer.ville).toSet().toList()..sort();

  /// Liste des entreprises disponibles
  static List<String> get availableCompanies =>
      sampleJobOffers.map((offer) => offer.entreprise).toSet().toList()..sort();

  /// Liste des compétences populaires
  static List<String> get popularSkills {
    final allSkills =
        sampleJobOffers.expand((offer) => offer.competencesRequises).toList();

    final skillCount = <String, int>{};
    for (final skill in allSkills) {
      skillCount[skill] = (skillCount[skill] ?? 0) + 1;
    }

    final sortedSkills = skillCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedSkills.map((entry) => entry.key).toList();
  }
}
