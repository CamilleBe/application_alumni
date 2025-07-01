// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alumni.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Alumni _$AlumniFromJson(Map<String, dynamic> json) {
  return _Alumni.fromJson(json);
}

/// @nodoc
mixin _$Alumni {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get statut => throw _privateConstructorUsedError;
  String? get entreprise => throw _privateConstructorUsedError;
  String? get poste => throw _privateConstructorUsedError;
  String? get ville => throw _privateConstructorUsedError;
  String? get anneePromotion => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Alumni to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Alumni
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlumniCopyWith<Alumni> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlumniCopyWith<$Res> {
  factory $AlumniCopyWith(Alumni value, $Res Function(Alumni) then) =
      _$AlumniCopyWithImpl<$Res, Alumni>;
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      String email,
      String? statut,
      String? entreprise,
      String? poste,
      String? ville,
      String? anneePromotion,
      String? bio,
      String? profileImageUrl,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AlumniCopyWithImpl<$Res, $Val extends Alumni>
    implements $AlumniCopyWith<$Res> {
  _$AlumniCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Alumni
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? statut = freezed,
    Object? entreprise = freezed,
    Object? poste = freezed,
    Object? ville = freezed,
    Object? anneePromotion = freezed,
    Object? bio = freezed,
    Object? profileImageUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      statut: freezed == statut
          ? _value.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as String?,
      entreprise: freezed == entreprise
          ? _value.entreprise
          : entreprise // ignore: cast_nullable_to_non_nullable
              as String?,
      poste: freezed == poste
          ? _value.poste
          : poste // ignore: cast_nullable_to_non_nullable
              as String?,
      ville: freezed == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String?,
      anneePromotion: freezed == anneePromotion
          ? _value.anneePromotion
          : anneePromotion // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AlumniImplCopyWith<$Res> implements $AlumniCopyWith<$Res> {
  factory _$$AlumniImplCopyWith(
          _$AlumniImpl value, $Res Function(_$AlumniImpl) then) =
      __$$AlumniImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      String email,
      String? statut,
      String? entreprise,
      String? poste,
      String? ville,
      String? anneePromotion,
      String? bio,
      String? profileImageUrl,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$AlumniImplCopyWithImpl<$Res>
    extends _$AlumniCopyWithImpl<$Res, _$AlumniImpl>
    implements _$$AlumniImplCopyWith<$Res> {
  __$$AlumniImplCopyWithImpl(
      _$AlumniImpl _value, $Res Function(_$AlumniImpl) _then)
      : super(_value, _then);

  /// Create a copy of Alumni
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? statut = freezed,
    Object? entreprise = freezed,
    Object? poste = freezed,
    Object? ville = freezed,
    Object? anneePromotion = freezed,
    Object? bio = freezed,
    Object? profileImageUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AlumniImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      statut: freezed == statut
          ? _value.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as String?,
      entreprise: freezed == entreprise
          ? _value.entreprise
          : entreprise // ignore: cast_nullable_to_non_nullable
              as String?,
      poste: freezed == poste
          ? _value.poste
          : poste // ignore: cast_nullable_to_non_nullable
              as String?,
      ville: freezed == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String?,
      anneePromotion: freezed == anneePromotion
          ? _value.anneePromotion
          : anneePromotion // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
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
class _$AlumniImpl extends _Alumni {
  const _$AlumniImpl(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.statut,
      this.entreprise,
      this.poste,
      this.ville,
      this.anneePromotion,
      this.bio,
      this.profileImageUrl,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$AlumniImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlumniImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String? statut;
  @override
  final String? entreprise;
  @override
  final String? poste;
  @override
  final String? ville;
  @override
  final String? anneePromotion;
  @override
  final String? bio;
  @override
  final String? profileImageUrl;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Alumni(id: $id, firstName: $firstName, lastName: $lastName, email: $email, statut: $statut, entreprise: $entreprise, poste: $poste, ville: $ville, anneePromotion: $anneePromotion, bio: $bio, profileImageUrl: $profileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlumniImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            (identical(other.entreprise, entreprise) ||
                other.entreprise == entreprise) &&
            (identical(other.poste, poste) || other.poste == poste) &&
            (identical(other.ville, ville) || other.ville == ville) &&
            (identical(other.anneePromotion, anneePromotion) ||
                other.anneePromotion == anneePromotion) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      firstName,
      lastName,
      email,
      statut,
      entreprise,
      poste,
      ville,
      anneePromotion,
      bio,
      profileImageUrl,
      createdAt,
      updatedAt);

  /// Create a copy of Alumni
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlumniImplCopyWith<_$AlumniImpl> get copyWith =>
      __$$AlumniImplCopyWithImpl<_$AlumniImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlumniImplToJson(
      this,
    );
  }
}

abstract class _Alumni extends Alumni {
  const factory _Alumni(
      {required final String id,
      required final String firstName,
      required final String lastName,
      required final String email,
      final String? statut,
      final String? entreprise,
      final String? poste,
      final String? ville,
      final String? anneePromotion,
      final String? bio,
      final String? profileImageUrl,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$AlumniImpl;
  const _Alumni._() : super._();

  factory _Alumni.fromJson(Map<String, dynamic> json) = _$AlumniImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get email;
  @override
  String? get statut;
  @override
  String? get entreprise;
  @override
  String? get poste;
  @override
  String? get ville;
  @override
  String? get anneePromotion;
  @override
  String? get bio;
  @override
  String? get profileImageUrl;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Alumni
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlumniImplCopyWith<_$AlumniImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
