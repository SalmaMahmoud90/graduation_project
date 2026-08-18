// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDataModel _$ReportDataModelFromJson(Map<String, dynamic> json) =>
    ReportDataModel(
      id: (json['id'] as num?)?.toInt(),
      reportedUser: (json['reported_user'] as num?)?.toInt(),
      ride: (json['ride'] as num?)?.toInt(),
      type: json['type'] as String?,
      reason: json['reason'] as String?,
      status: json['status'] as String?,
      adminNote: json['admin_note'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

ReportsListModel _$ReportsListModelFromJson(Map<String, dynamic> json) =>
    ReportsListModel(
      reports: (json['reports'] as List<dynamic>?)
          ?.map((e) => ReportDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
