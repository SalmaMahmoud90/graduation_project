import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

// نموذج بيانات الملف الشخصي (view_profile) — يغطي السائق والراكب معًا
@JsonSerializable(createToJson: false)
class ProfileModel extends Equatable {
  final ProfileUserModel? user;
  @JsonKey(name: 'car_model')
  final String? carModel;
  @JsonKey(name: 'car_number')
  final String? carNumber;
  @JsonKey(name: 'car_color')
  final String? carColor;
  @JsonKey(name: 'car_image')
  final String? carImage;
  @JsonKey(name: 'current_location')
  final String? currentLocation;

  const ProfileModel({
    this.user,
    this.carModel,
    this.carNumber,
    this.carColor,
    this.carImage,
    this.currentLocation,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  @override
  List<Object?> get props =>
      [user, carModel, carNumber, carColor, carImage, currentLocation];
}

@JsonSerializable(createToJson: false)
class ProfileUserModel extends Equatable {
  final String? name;
  final String? phone;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;

  const ProfileUserModel({
    this.name,
    this.phone,
    this.createdAt,
    this.profilePicture,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileUserModelFromJson(json);

  @override
  List<Object?> get props => [name, phone, createdAt, profilePicture];
}
