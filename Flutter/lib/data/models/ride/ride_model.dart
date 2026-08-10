// نموذج بيانات الرحلة
class RideModel {
  final String id;
  final String departureCity;
  final String destinationCity;
  final DateTime departureDateTime;
  final String duration;
  final double price;
  final int availableSeats;
  final double? latitude;
  final double? longitude;
  final bool isCompleted;

  RideModel({
    required this.id,
    required this.departureCity,
    required this.destinationCity,
    required this.departureDateTime,
    required this.duration,
    required this.price,
    required this.availableSeats,
    this.latitude,
    this.longitude,
    this.isCompleted = false,
  });

  // فحص هل يمكن تعديل الرحلة (أن يتبقى أكثر من 6 ساعات على الانطلاق)
  bool get isEditable {
    final difference = departureDateTime.difference(DateTime.now());
    return difference.inHours >= 6;
  }
}