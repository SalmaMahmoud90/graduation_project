import 'package:equatable/equatable.dart';

// كيان إنشاء بلاغ ضد مستخدم
class CreateReportEntity extends Equatable {
  final int userId;
  final String type;
  final String reason;
  final int? ride;

  const CreateReportEntity({
    required this.userId,
    required this.type,
    required this.reason,
    this.ride,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "reason": reason,
        if (ride != null) "ride": ride,
      };

  @override
  List<Object?> get props => [userId, type, reason, ride];
}

