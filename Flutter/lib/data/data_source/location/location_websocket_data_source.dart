import 'dart:async';
import 'dart:convert';
import 'package:a_tareqaak/data/models/location/location_update_model.dart';
import 'package:a_tareqaak/domain/entity/location/send_location_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable()
class LocationWebSocketDataSource {
  WebSocketChannel? _channel;
  StreamController<LocationUpdateModel>? _locationStreamController;

  Stream<LocationUpdateModel> get locationStream =>
      _locationStreamController?.stream ?? const Stream.empty();

  bool get isConnected => _channel != null;

  Future<Either<AppException, Unit>> connect({
    required int rideId,
    required String token,
  }) async {
    try {
      await disconnect();

      _locationStreamController = StreamController<LocationUpdateModel>.broadcast();

      final uri = Uri.parse(
        'wss://api.atareeqak.tech/ws/location/$rideId/?token=$token',
      );

      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;

      _channel!.stream.listen(
        (dynamic message) {
          try {
            final Map<String, dynamic> data = jsonDecode(message as String);
            if (data['type'] == 'location_update' || data.containsKey('latitude')) {
              final model = LocationUpdateModel.fromJson(data);
              _locationStreamController?.add(model);
            }
          } catch (e) {
            debugPrint('⚠️ Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          debugPrint('🚨 WebSocket Error: $error');
          _locationStreamController?.addError(
            AppException('حدث خطأ في الاتصال المباشر بالخادم'),
          );
        },
        onDone: () {
          debugPrint('🔌 WebSocket Closed');
        },
        cancelOnError: false,
      );

      return const Right(unit);
    } catch (e) {
      debugPrint('🚨 Failed to connect to WebSocket: $e');
      return Left(AppException('تعذر الاتصال بخادم التتبع المباشر: $e'));
    }
  }

  Future<Either<AppException, Unit>> sendLocation(SendLocationEntity data) async {
    if (_channel == null) {
      return Left(AppException('الاتصال بالخادم غير نشط'));
    }
    try {
      final payload = jsonEncode(data.toJson());
      _channel!.sink.add(payload);
      return const Right(unit);
    } catch (e) {
      return Left(AppException('فشل في إرسال الموقع: $e'));
    }
  }

  Future<Either<AppException, Unit>> disconnect() async {
    try {
      if (_channel != null) {
        await _channel!.sink.close(status.normalClosure);
        _channel = null;
      }
      if (_locationStreamController != null &&
          !_locationStreamController!.isClosed) {
        await _locationStreamController!.close();
        _locationStreamController = null;
      }
      return const Right(unit);
    } catch (e) {
      return Left(AppException('خطأ أثناء قطع الاتصال: $e'));
    }
  }
}