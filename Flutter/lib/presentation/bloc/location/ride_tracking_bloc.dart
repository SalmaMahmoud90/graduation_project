import 'dart:async';
import 'dart:developer';
import 'package:a_tareqaak/domain/entity/location/ride_tracking_connection_entity.dart';
import 'package:a_tareqaak/domain/entity/location/send_location_entity.dart';
import 'package:a_tareqaak/domain/usecase/location/listen_to_location_update_usecase.dart';
import 'package:a_tareqaak/presentation/bloc/location/i_ride_tracking_event.dart';
import 'package:a_tareqaak/presentation/bloc/location/i_ride_tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';

import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


class RideTrackingBloc extends Bloc<IRideTrackingEvent, IRideTrackingState> {
  StreamSubscription? _locationSubscription;

  RideTrackingBloc() : super(RideTrackingInitial()) {
    on<ConnectToRideTrackingEvent>(_onConnect);
    on<SendDriverLocationEvent>(_onSendLocation);
    on<OnLocationReceivedInternalEvent>(_onLocationReceived);
    on<DisconnectFromRideTrackingEvent>(_onDisconnect);
  }

  FutureOr<void> _onConnect(
    ConnectToRideTrackingEvent event,
    Emitter<IRideTrackingState> emit,
  ) async {
    emit(RideTrackingConnecting());
    try {
      final connectUseCase = locator<
          IUseCase<Unit, RideTrackingConnectionEntity>>(
        instanceName: 'ConnectToRideTrackingUseCase',
      );

      final result = await connectUseCase(event.entity);

      await result.fold(
        (failure) async {
          emit(RideTrackingFailed(failure.message));
        },
        (success) async {
          emit(RideTrackingConnected());
          await _locationSubscription?.cancel();
          final listenUseCase = locator<ListenToLocationUpdatesUseCase>();
          _locationSubscription = listenUseCase().listen(
            (locationEntity) {
              add(OnLocationReceivedInternalEvent(locationEntity));
            },
            onError: (error) {
              add(const DisconnectFromRideTrackingEvent());
            },
          );
        },
      );
    } catch (e, s) {
      log('RideTrackingBloc Error: $e\n$s');
      emit(RideTrackingFailed(e.toString()));
    }
  }

  FutureOr<void> _onSendLocation(
    SendDriverLocationEvent event,
    Emitter<IRideTrackingState> emit,
  ) async {
    try {
      final sendLocationUseCase = locator<
          IUseCase<Unit, SendLocationEntity>>(
        instanceName: 'SendLocationUseCase',
      );
      await sendLocationUseCase(event.entity);
    } catch (e) {
      log('Error sending location: $e');
    }
  }

  FutureOr<void> _onLocationReceived(
    OnLocationReceivedInternalEvent event,
    Emitter<IRideTrackingState> emit,
  ) {
    emit(RideTrackingLocationReceived(event.entity));
  }

  FutureOr<void> _onDisconnect(
    DisconnectFromRideTrackingEvent event,
    Emitter<IRideTrackingState> emit,
  ) async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    try {
      final disconnectUseCase = locator<
          IUseCase<Unit, NoParams>>(
        instanceName: 'DisconnectFromRideTrackingUseCase',
      );
      await disconnectUseCase(const NoParams());
    } catch (_) {}
    emit(RideTrackingDisconnected());
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}