// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  user: json['user'] == null
      ? null
      : ProfileUserModel.fromJson(json['user'] as Map<String, dynamic>),
  carModel: json['car_model'] as String?,
  carNumber: json['car_number'] as String?,
  carColor: json['car_color'] as String?,
  carImage: json['car_image'] as String?,
  currentLocation: json['current_location'] as String?,
);

ProfileUserModel _$ProfileUserModelFromJson(Map<String, dynamic> json) =>
    ProfileUserModel(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] as String?,
      profilePicture: json['profile_picture'] as String?,
    );
