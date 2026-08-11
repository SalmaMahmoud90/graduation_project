import 'package:equatable/equatable.dart';

// كيان يحمل معرّفًا فقط — يُستخدم لإلغاء الرحلة/الحجز، القبول، الرفض، والتفاصيل
class IdEntity extends Equatable {
  final int id;

  const IdEntity(this.id);

  @override
  List<Object?> get props => [id];
}
