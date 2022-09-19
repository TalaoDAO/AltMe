import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beacon_cubit.g.dart';
part 'beacon_state.dart';

class BeaconCubit extends Cubit<BeaconState> {
  BeaconCubit({required this.beacon}) : super(const BeaconState());

  final Beacon beacon;

  final log = getLogger('BeaconCubit');
  Future<void> startBeacon() async {
    await beacon.startBeacon();
    if (state.isBeaconStarted) return;
    log.i('beacon started');
    emit(state.copyWith(isBeaconStarted: true));
    Future.delayed(const Duration(seconds: 1), listenToBeacon);
  }

  void listenToBeacon() {
    log.i('listening to beacon');
    beacon.getBeaconResponse().listen(
      (data) {
        final Map<String, dynamic> requestJson =
            jsonDecode(data) as Map<String, dynamic>;
        final BeaconRequest beaconRequest = BeaconRequest.fromJson(requestJson);

        log.i('beacon response - $BeaconState');
        switch (beaconRequest.type) {
          case RequestType.permission:
            emit(
              state.copyWith(
                status: BeaconStatus.permission,
                beaconRequest: beaconRequest,
              ),
            );
            break;
          case RequestType.signPayload:
            emit(
              state.copyWith(
                status: BeaconStatus.signPayload,
                beaconRequest: beaconRequest,
              ),
            );
            break;
          case RequestType.operation:
            emit(
              state.copyWith(
                status: BeaconStatus.operation,
                beaconRequest: beaconRequest,
              ),
            );
            break;
          case RequestType.broadcast:
            emit(
              state.copyWith(
                status: BeaconStatus.broadcast,
                beaconRequest: beaconRequest,
              ),
            );
            break;
          // ignore: no_default_cases
          default:
        }
      },
    );
  }
}
