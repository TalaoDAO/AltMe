import 'package:altme/app/app.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_cubit.g.dart';
part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required this.beacon}) : super(const DashboardState()) {
    listenToBeacon();
  }

  final Beacon beacon;

  Future<void> listenToBeacon() async {
    beacon.getBeaconResponse().listen(
      (data) async {
        debugPrint(data);
        Future<void>.delayed(const Duration(seconds: 2), () async {
          await beacon.respondExample();
        });
      },
    );
  }

  Future<void> onPageChanged(int index) async {
    emit(state.copyWith(selectedIndex: index));
  }
}
