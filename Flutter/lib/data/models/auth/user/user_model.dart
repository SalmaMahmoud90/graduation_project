import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

// مودل بيانات المستخدم
@JsonSerializable(createToJson: false)
class UserModel extends Equatable {
  final String? email;
  final String? name;
  @JsonKey(name: 'user_type')
  final String? userType;
  final String? phone;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const UserModel({
    this.email,
    this.name,
    this.userType,
    this.phone,
    this.profilePicture,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  List<Object?> get props => [
        email,
        name,
        userType,
        phone,
        profilePicture,
        createdAt,
      ];
}