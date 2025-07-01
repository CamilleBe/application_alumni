import 'package:freezed_annotation/freezed_annotation.dart';

part 'alumni.freezed.dart';
part 'alumni.g.dart';

@freezed
class Alumni with _$Alumni {
  // Constructeur privé requis pour les getters

  const factory Alumni({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    String? statut,
    String? entreprise,
    String? poste,
    String? ville,
    String? anneePromotion,
    String? bio,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Alumni;
  const Alumni._();

  factory Alumni.fromJson(Map<String, dynamic> json) => _$AlumniFromJson(json);

  /// Méthode helper pour le nom complet
  String get fullName => '$firstName $lastName';

  /// Méthode helper pour vérifier si c'est un alumni
  bool get isAlumni => statut?.toLowerCase() == 'alumni';
}
