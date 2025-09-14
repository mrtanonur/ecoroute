import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String? fullName;
  final String email;
  final String? signInMethod;

  UserModel({
    required this.id,
    this.fullName,
    required this.email,
    this.signInMethod,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? signInMethod,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      signInMethod: signInMethod ?? this.signInMethod,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
