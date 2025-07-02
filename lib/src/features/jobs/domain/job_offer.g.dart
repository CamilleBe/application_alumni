// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobOfferImpl _$$JobOfferImplFromJson(Map<String, dynamic> json) =>
    _$JobOfferImpl(
      id: json['id'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String,
      entreprise: json['entreprise'] as String,
      ville: json['ville'] as String,
      type: $enumDecode(_$JobOfferTypeEnumMap, json['type']),
      datePublication: DateTime.parse(json['datePublication'] as String),
      dateLimite: DateTime.parse(json['dateLimite'] as String),
      publisherId: json['publisherId'] as String,
      statut: $enumDecodeNullable(_$JobOfferStatusEnumMap, json['statut']) ??
          JobOfferStatus.active,
      competencesRequises: (json['competencesRequises'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      niveauEtude: json['niveauEtude'] as String?,
      typeContrat: json['typeContrat'] as String?,
      salaire: json['salaire'] as String?,
      urlEntreprise: json['urlEntreprise'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactTelephone: json['contactTelephone'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$JobOfferImplToJson(_$JobOfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'description': instance.description,
      'entreprise': instance.entreprise,
      'ville': instance.ville,
      'type': _$JobOfferTypeEnumMap[instance.type]!,
      'datePublication': instance.datePublication.toIso8601String(),
      'dateLimite': instance.dateLimite.toIso8601String(),
      'publisherId': instance.publisherId,
      'statut': _$JobOfferStatusEnumMap[instance.statut]!,
      'competencesRequises': instance.competencesRequises,
      'niveauEtude': instance.niveauEtude,
      'typeContrat': instance.typeContrat,
      'salaire': instance.salaire,
      'urlEntreprise': instance.urlEntreprise,
      'contactEmail': instance.contactEmail,
      'contactTelephone': instance.contactTelephone,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$JobOfferTypeEnumMap = {
  JobOfferType.stage: 'stage',
  JobOfferType.emploi: 'emploi',
};

const _$JobOfferStatusEnumMap = {
  JobOfferStatus.active: 'active',
  JobOfferStatus.fermee: 'fermee',
  JobOfferStatus.pourvue: 'pourvue',
};
