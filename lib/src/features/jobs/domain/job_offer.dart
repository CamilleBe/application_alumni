import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_offer.freezed.dart';
part 'job_offer.g.dart';

/// Énumération pour le type d'offre
enum JobOfferType {
  @JsonValue('stage')
  stage('Stage'),
  @JsonValue('emploi')
  emploi('Emploi');

  const JobOfferType(this.displayName);
  final String displayName;
}

/// Énumération pour le statut de l'offre
enum JobOfferStatus {
  @JsonValue('active')
  active('Active'),
  @JsonValue('fermee')
  fermee('Fermée'),
  @JsonValue('pourvue')
  pourvue('Pourvue');

  const JobOfferStatus(this.displayName);
  final String displayName;
}

/// Modèle représentant une offre d'emploi ou de stage
@freezed
class JobOffer with _$JobOffer {
  const factory JobOffer({
    required String id,
    required String titre,
    required String description,
    required String entreprise,
    required String ville,
    required JobOfferType type,
    required DateTime datePublication,
    required DateTime dateLimite,
    required String publisherId, // ID de l'alumni qui publie
    @Default(JobOfferStatus.active) JobOfferStatus statut,
    @Default([]) List<String> competencesRequises,
    String? niveauEtude,
    String? typeContrat,
    String? salaire,
    String? urlEntreprise,
    String? contactEmail,
    String? contactTelephone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JobOffer;

  const JobOffer._();

  /// Factory pour créer depuis JSON
  factory JobOffer.fromJson(Map<String, dynamic> json) =>
      _$JobOfferFromJson(json);

  /// Getters personnalisés

  /// Vérifie si l'offre est encore active
  bool get isActive =>
      statut == JobOfferStatus.active && DateTime.now().isBefore(dateLimite);

  /// Vérifie si l'offre est expirée
  bool get isExpired => DateTime.now().isAfter(dateLimite);

  /// Nombre de jours restants avant la date limite
  int get daysUntilDeadline {
    if (isExpired) return 0;
    return dateLimite.difference(DateTime.now()).inDays;
  }

  /// Texte formaté pour la date limite
  String get deadlineText {
    if (isExpired) return 'Expirée';
    final days = daysUntilDeadline;
    if (days == 0) return "Expire aujourd'hui";
    if (days == 1) return 'Expire demain';
    return 'Expire dans $days jours';
  }

  /// Icône selon le type d'offre
  String get typeIcon {
    switch (type) {
      case JobOfferType.stage:
        return '🎓';
      case JobOfferType.emploi:
        return '💼';
    }
  }

  /// Couleur selon le statut
  String get statusColor {
    switch (statut) {
      case JobOfferStatus.active:
        return '#4CAF50'; // Vert
      case JobOfferStatus.fermee:
        return '#757575'; // Gris
      case JobOfferStatus.pourvue:
        return '#2196F3'; // Bleu
    }
  }

  /// Version courte de la description (preview)
  String get shortDescription {
    if (description.length <= 150) return description;
    return '${description.substring(0, 147)}...';
  }

  /// Liste des compétences formatée
  String get competencesText {
    if (competencesRequises.isEmpty) return 'Aucune compétence spécifiée';
    return competencesRequises.join(', ');
  }
}
