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
    await beacon.startBeacon(walletName: 'Altme');
    if (state.isBeaconStarted) return;
    log.i('beacon started');
    emit(state.copyWith(isBeaconStarted: true));
    Future.delayed(const Duration(seconds: 1), listenToBeacon);
  }

  Future<void> peerFromDeepLink(String beaconData) async {
    final isInternetAvailable = await isConnected();
    if (isInternetAvailable && isBeaconRequestAllowed()) {
      await beacon.pair(pairingRequest: beaconData);
    }
  }

  bool isBeaconRequestAllowed() {
    final DateTime currentTime = DateTime.now();
    final lastBeaconRequestTime = state.lastBeaconRequestTime;
    bool isBeaconRequestAllowed = true;
    if (lastBeaconRequestTime != null) {
      final difference = currentTime.difference(lastBeaconRequestTime);
      if (difference < const Duration(seconds: 1)) {
        isBeaconRequestAllowed = false;
      }
    }
    emit(
      state.copyWith(
        lastBeaconRequestTime: DateTime.now(),
      ),
    );
    return isBeaconRequestAllowed;
  }

  void listenToBeacon() {
    try {
      log.i('listening to beacon');
      beacon.getBeaconResponse().listen(
        (data) {
          final Map<String, dynamic> requestJson =
              jsonDecode(data) as Map<String, dynamic>;
          final BeaconRequest beaconRequest =
              BeaconRequest.fromJson(requestJson);

          log.i('beacon response - $requestJson');
          log.i('beaconRequest.type - ${beaconRequest.type}');
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
              if (isBeaconRequestAllowed()) {
                emit(
                  state.copyWith(
                    status: BeaconStatus.signPayload,
                    beaconRequest: beaconRequest,
                  ),
                );
              }
              break;
            case RequestType.operation:
              if (isBeaconRequestAllowed()) {
                emit(
                  state.copyWith(
                    status: BeaconStatus.operation,
                    beaconRequest: beaconRequest,
                  ),
                );
              }
              break;
            case RequestType.broadcast:
              if (isBeaconRequestAllowed()) {
                emit(
                  state.copyWith(
                    status: BeaconStatus.broadcast,
                    beaconRequest: beaconRequest,
                  ),
                );
              }
              break;
            // ignore: no_default_cases
            default:
          }
        },
      );
    } catch (e) {
      log.e('beacon listening error - $e');
    }
  }
}
