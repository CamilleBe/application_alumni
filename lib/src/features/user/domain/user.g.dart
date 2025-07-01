// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      entreprise: json['entreprise'] as String?,
      statut: json['statut'] as String?,
      bio: json['bio'] as String?,
      ville: json['ville'] as String?,
      anneePromotion: json['anneePromotion'] as String?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'entreprise': instance.entreprise,
      'statut': instance.statut,
      'bio': instance.bio,
      'ville': instance.ville,
      'anneePromotion': instance.anneePromotion,
    };
