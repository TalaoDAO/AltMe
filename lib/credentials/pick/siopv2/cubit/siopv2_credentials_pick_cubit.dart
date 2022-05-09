import 'package:altme/credentials/credential.dart';
import 'package:altme/qr_code/qr_code.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
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
    if (state.index == index) return;
    emit(state.copyWith(index: index));
  }

  Future<void> presentCredentialToSIOPV2Request({
    required CredentialModel credential,
    required SIOPV2Param sIOPV2Param,
  }) async {
    emit(SIOPV2CredentialPresentState(index: state.index, loading: true));
    await scanCubit.presentCredentialToSiopV2Request(
      credential: credential,
      sIOPV2Param: sIOPV2Param,
    );
    emit(state.copyWith(loading: false));
  }
}
