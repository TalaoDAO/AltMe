import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/scan/scan.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'siopv2_credentials_pick_cubit.g.dart';

part 'siopv2_credentials_pick_state.dart';

class SIOPV2CredentialPickCubit extends Cubit<SIOPV2CredentialPickState> {
  SIOPV2CredentialPickCubit({required this.scanCubit})
      : super(const SIOPV2CredentialPickState());

  final ScanCubit scanCubit;

  void toggle(int index) {
    emit(state.copyWith(index: index));
  }

  Future<void> presentCredentialToSIOPV2Request({
    required CredentialModel credential,
    required SIOPV2Param sIOPV2Param,
    required Issuer issuer,
  }) async {
    emit(state.copyWith(index: state.index, status: AppStatus.loading));
    await scanCubit.presentCredentialToSiopV2Request(
      credential: credential,
      sIOPV2Param: sIOPV2Param,
      issuer: issuer,
    );
    emit(state.copyWith(status: AppStatus.success));
  }
}
