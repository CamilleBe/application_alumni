import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

typedef UserID = String;

@freezed
class User with _$User {
  const factory User({
    required UserID id,
    required String firstName,
    required String lastName,
    required String email,
    String? entreprise,
    String? statut,
    String? bio,
    String? ville,
    String? anneePromotion,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
