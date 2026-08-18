

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_data_model.g.dart';

// نموذج بيانات البلاغ القادم من الـ API
@JsonSerializable(createToJson: false)
class ReportDataModel extends Equatable {
  final int? id;
  @JsonKey(name: 'reported_user')
  final int? reportedUser;
  final int? ride;
  final String? type;
  final String? reason;
  final String? status;
  @JsonKey(name: 'admin_note')
  final String? adminNote;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const ReportDataModel({
    this.id,
    this.reportedUser,
    this.ride,
    this.type,
    this.reason,
    this.status,
    this.adminNote,
    this.createdAt,
    this.updatedAt,
  });

  factory ReportDataModel.fromJson(Map<String, dynamic> json) =>
      _$ReportDataModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        reportedUser,
        ride,
        type,
        reason,
        status,
        adminNote,
        createdAt,
        updatedAt,
      ];
}

// غلاف قائمة البلاغات
@JsonSerializable(createToJson: false)
class ReportsListModel extends Equatable {
  final List<ReportDataModel>? reports;

  const ReportsListModel({this.reports});

  factory ReportsListModel.fromJson(Map<String, dynamic> json) =>
      _$ReportsListModelFromJson(json);

  @override
  List<Object?> get props => [reports];
}