import 'package:altme/app/app.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beacon_cubit.g.dart';
part 'beacon_state.dart';

class BeaconCubit extends Cubit<BeaconState> {
  BeaconCubit({required this.beacon}) : super(const BeaconState());

  final Beacon beacon;

  Future<void> startBeacon() async {
    await beacon.startBeacon();
    listenToBeacon();
  }

  void listenToBeacon() {
    beacon.getBeaconResponse().listen(
      (data) async {
        debugPrint(data);
        Future<void>.delayed(const Duration(seconds: 2), () async {
          await beacon.respondExample();
        });
      },
    );
  }
}
