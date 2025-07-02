// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JobOffer _$JobOfferFromJson(Map<String, dynamic> json) {
  return _JobOffer.fromJson(json);
}

/// @nodoc
mixin _$JobOffer {
  String get id => throw _privateConstructorUsedError;
  String get titre => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get entreprise => throw _privateConstructorUsedError;
  String get ville => throw _privateConstructorUsedError;
  JobOfferType get type => throw _privateConstructorUsedError;
  DateTime get datePublication => throw _privateConstructorUsedError;
  DateTime get dateLimite => throw _privateConstructorUsedError;
  String get publisherId =>
      throw _privateConstructorUsedError; // ID de l'alumni qui publie
  JobOfferStatus get statut => throw _privateConstructorUsedError;
  List<String> get competencesRequises => throw _privateConstructorUsedError;
  String? get niveauEtude => throw _privateConstructorUsedError;
  String? get typeContrat => throw _privateConstructorUsedError;
  String? get salaire => throw _privateConstructorUsedError;
  String? get urlEntreprise => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  String? get contactTelephone => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this JobOffer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobOfferCopyWith<JobOffer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobOfferCopyWith<$Res> {
  factory $JobOfferCopyWith(JobOffer value, $Res Function(JobOffer) then) =
      _$JobOfferCopyWithImpl<$Res, JobOffer>;
  @useResult
  $Res call(
      {String id,
      String titre,
      String description,
      String entreprise,
      String ville,
      JobOfferType type,
      DateTime datePublication,
      DateTime dateLimite,
      String publisherId,
      JobOfferStatus statut,
      List<String> competencesRequises,
      String? niveauEtude,
      String? typeContrat,
      String? salaire,
      String? urlEntreprise,
      String? contactEmail,
      String? contactTelephone,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$JobOfferCopyWithImpl<$Res, $Val extends JobOffer>
    implements $JobOfferCopyWith<$Res> {
  _$JobOfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titre = null,
    Object? description = null,
    Object? entreprise = null,
    Object? ville = null,
    Object? type = null,
    Object? datePublication = null,
    Object? dateLimite = null,
    Object? publisherId = null,
    Object? statut = null,
    Object? competencesRequises = null,
    Object? niveauEtude = freezed,
    Object? typeContrat = freezed,
    Object? salaire = freezed,
    Object? urlEntreprise = freezed,
    Object? contactEmail = freezed,
    Object? contactTelephone = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titre: null == titre
          ? _value.titre
          : titre // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      entreprise: null == entreprise
          ? _value.entreprise
          : entreprise // ignore: cast_nullable_to_non_nullable
              as String,
      ville: null == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as JobOfferType,
      datePublication: null == datePublication
          ? _value.datePublication
          : datePublication // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateLimite: null == dateLimite
          ? _value.dateLimite
          : dateLimite // ignore: cast_nullable_to_non_nullable
              as DateTime,
      publisherId: null == publisherId
          ? _value.publisherId
          : publisherId // ignore: cast_nullable_to_non_nullable
              as String,
      statut: null == statut
          ? _value.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as JobOfferStatus,
      competencesRequises: null == competencesRequises
          ? _value.competencesRequises
          : competencesRequises // ignore: cast_nullable_to_non_nullable
              as List<String>,
      niveauEtude: freezed == niveauEtude
          ? _value.niveauEtude
          : niveauEtude // ignore: cast_nullable_to_non_nullable
              as String?,
      typeContrat: freezed == typeContrat
          ? _value.typeContrat
          : typeContrat // ignore: cast_nullable_to_non_nullable
              as String?,
      salaire: freezed == salaire
          ? _value.salaire
          : salaire // ignore: cast_nullable_to_non_nullable
              as String?,
      urlEntreprise: freezed == urlEntreprise
          ? _value.urlEntreprise
          : urlEntreprise // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactTelephone: freezed == contactTelephone
          ? _value.contactTelephone
          : contactTelephone // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobOfferImplCopyWith<$Res>
    implements $JobOfferCopyWith<$Res> {
  factory _$$JobOfferImplCopyWith(
          _$JobOfferImpl value, $Res Function(_$JobOfferImpl) then) =
      __$$JobOfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String titre,
      String description,
      String entreprise,
      String ville,
      JobOfferType type,
      DateTime datePublication,
      DateTime dateLimite,
      String publisherId,
      JobOfferStatus statut,
      List<String> competencesRequises,
      String? niveauEtude,
      String? typeContrat,
      String? salaire,
      String? urlEntreprise,
      String? contactEmail,
      String? contactTelephone,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$JobOfferImplCopyWithImpl<$Res>
    extends _$JobOfferCopyWithImpl<$Res, _$JobOfferImpl>
    implements _$$JobOfferImplCopyWith<$Res> {
  __$$JobOfferImplCopyWithImpl(
      _$JobOfferImpl _value, $Res Function(_$JobOfferImpl) _then)
      : super(_value, _then);

  /// Create a copy of JobOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titre = null,
    Object? description = null,
    Object? entreprise = null,
    Object? ville = null,
    Object? type = null,
    Object? datePublication = null,
    Object? dateLimite = null,
    Object? publisherId = null,
    Object? statut = null,
    Object? competencesRequises = null,
    Object? niveauEtude = freezed,
    Object? typeContrat = freezed,
    Object? salaire = freezed,
    Object? urlEntreprise = freezed,
    Object? contactEmail = freezed,
    Object? contactTelephone = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$JobOfferImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titre: null == titre
          ? _value.titre
          : titre // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      entreprise: null == entreprise
          ? _value.entreprise
          : entreprise // ignore: cast_nullable_to_non_nullable
              as String,
      ville: null == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as JobOfferType,
      datePublication: null == datePublication
          ? _value.datePublication
          : datePublication // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateLimite: null == dateLimite
          ? _value.dateLimite
          : dateLimite // ignore: cast_nullable_to_non_nullable
              as DateTime,
      publisherId: null == publisherId
          ? _value.publisherId
          : publisherId // ignore: cast_nullable_to_non_nullable
              as String,
      statut: null == statut
          ? _value.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as JobOfferStatus,
      competencesRequises: null == competencesRequises
          ? _value._competencesRequises
          : competencesRequises // ignore: cast_nullable_to_non_nullable
              as List<String>,
      niveauEtude: freezed == niveauEtude
          ? _value.niveauEtude
          : niveauEtude // ignore: cast_nullable_to_non_nullable
              as String?,
      typeContrat: freezed == typeContrat
          ? _value.typeContrat
          : typeContrat // ignore: cast_nullable_to_non_nullable
              as String?,
      salaire: freezed == salaire
          ? _value.salaire
          : salaire // ignore: cast_nullable_to_non_nullable
              as String?,
      urlEntreprise: freezed == urlEntreprise
          ? _value.urlEntreprise
          : urlEntreprise // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactTelephone: freezed == contactTelephone
          ? _value.contactTelephone
          : contactTelephone // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JobOfferImpl extends _JobOffer {
  const _$JobOfferImpl(
      {required this.id,
      required this.titre,
      required this.description,
      required this.entreprise,
      required this.ville,
      required this.type,
      required this.datePublication,
      required this.dateLimite,
      required this.publisherId,
      this.statut = JobOfferStatus.active,
      final List<String> competencesRequises = const [],
      this.niveauEtude,
      this.typeContrat,
      this.salaire,
      this.urlEntreprise,
      this.contactEmail,
      this.contactTelephone,
      this.createdAt,
      this.updatedAt})
      : _competencesRequises = competencesRequises,
        super._();

  factory _$JobOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobOfferImplFromJson(json);

  @override
  final String id;
  @override
  final String titre;
  @override
  final String description;
  @override
  final String entreprise;
  @override
  final String ville;
  @override
  final JobOfferType type;
  @override
  final DateTime datePublication;
  @override
  final DateTime dateLimite;
  @override
  final String publisherId;
// ID de l'alumni qui publie
  @override
  @JsonKey()
  final JobOfferStatus statut;
  final List<String> _competencesRequises;
  @override
  @JsonKey()
  List<String> get competencesRequises {
    if (_competencesRequises is EqualUnmodifiableListView)
      return _competencesRequises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_competencesRequises);
  }

  @override
  final String? niveauEtude;
  @override
  final String? typeContrat;
  @override
  final String? salaire;
  @override
  final String? urlEntreprise;
  @override
  final String? contactEmail;
  @override
  final String? contactTelephone;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'JobOffer(id: $id, titre: $titre, description: $description, entreprise: $entreprise, ville: $ville, type: $type, datePublication: $datePublication, dateLimite: $dateLimite, publisherId: $publisherId, statut: $statut, competencesRequises: $competencesRequises, niveauEtude: $niveauEtude, typeContrat: $typeContrat, salaire: $salaire, urlEntreprise: $urlEntreprise, contactEmail: $contactEmail, contactTelephone: $contactTelephone, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobOfferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titre, titre) || other.titre == titre) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.entreprise, entreprise) ||
                other.entreprise == entreprise) &&
            (identical(other.ville, ville) || other.ville == ville) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.datePublication, datePublication) ||
                other.datePublication == datePublication) &&
            (identical(other.dateLimite, dateLimite) ||
                other.dateLimite == dateLimite) &&
            (identical(other.publisherId, publisherId) ||
                other.publisherId == publisherId) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            const DeepCollectionEquality()
                .equals(other._competencesRequises, _competencesRequises) &&
            (identical(other.niveauEtude, niveauEtude) ||
                other.niveauEtude == niveauEtude) &&
            (identical(other.typeContrat, typeContrat) ||
                other.typeContrat == typeContrat) &&
            (identical(other.salaire, salaire) || other.salaire == salaire) &&
            (identical(other.urlEntreprise, urlEntreprise) ||
                other.urlEntreprise == urlEntreprise) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.contactTelephone, contactTelephone) ||
                other.contactTelephone == contactTelephone) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        titre,
        description,
        entreprise,
        ville,
        type,
        datePublication,
        dateLimite,
        publisherId,
        statut,
        const DeepCollectionEquality().hash(_competencesRequises),
        niveauEtude,
        typeContrat,
        salaire,
        urlEntreprise,
        contactEmail,
        contactTelephone,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of JobOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobOfferImplCopyWith<_$JobOfferImpl> get copyWith =>
      __$$JobOfferImplCopyWithImpl<_$JobOfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobOfferImplToJson(
      this,
    );
  }
}

abstract class _JobOffer extends JobOffer {
  const factory _JobOffer(
      {required final String id,
      required final String titre,
      required final String description,
      required final String entreprise,
      required final String ville,
      required final JobOfferType type,
      required final DateTime datePublication,
      required final DateTime dateLimite,
      required final String publisherId,
      final JobOfferStatus statut,
      final List<String> competencesRequises,
      final String? niveauEtude,
      final String? typeContrat,
      final String? salaire,
      final String? urlEntreprise,
      final String? contactEmail,
      final String? contactTelephone,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$JobOfferImpl;
  const _JobOffer._() : super._();

  factory _JobOffer.fromJson(Map<String, dynamic> json) =
      _$JobOfferImpl.fromJson;

  @override
  String get id;
  @override
  String get titre;
  @override
  String get description;
  @override
  String get entreprise;
  @override
  String get ville;
  @override
  JobOfferType get type;
  @override
  DateTime get datePublication;
  @override
  DateTime get dateLimite;
  @override
  String get publisherId; // ID de l'alumni qui publie
  @override
  JobOfferStatus get statut;
  @override
  List<String> get competencesRequises;
  @override
  String? get niveauEtude;
  @override
  String? get typeContrat;
  @override
  String? get salaire;
  @override
  String? get urlEntreprise;
  @override
  String? get contactEmail;
  @override
  String? get contactTelephone;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of JobOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobOfferImplCopyWith<_$JobOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
