// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlumniImpl _$$AlumniImplFromJson(Map<String, dynamic> json) => _$AlumniImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      statut: json['statut'] as String?,
      entreprise: json['entreprise'] as String?,
      poste: json['poste'] as String?,
      ville: json['ville'] as String?,
      anneePromotion: json['anneePromotion'] as String?,
      bio: json['bio'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AlumniImplToJson(_$AlumniImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'statut': instance.statut,
      'entreprise': instance.entreprise,
      'poste': instance.poste,
      'ville': instance.ville,
      'anneePromotion': instance.anneePromotion,
      'bio': instance.bio,
      'profileImageUrl': instance.profileImageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
