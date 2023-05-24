import 'package:altme/app/app.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polygonid/polygonid.dart';
import 'package:secure_storage/secure_storage.dart';

part 'polygon_id_verification_cubit.g.dart';
part 'polygon_id_verification_state.dart';

class PolygonIdVerificationCubit extends Cubit<PolygonIdVerificationState> {
  PolygonIdVerificationCubit({
    required this.secureStorageProvider,
    required this.polygonIdCubit,
  }) : super(PolygonIdVerificationState());

  final SecureStorageProvider secureStorageProvider;
  final PolygonIdCubit polygonIdCubit;

  Future<void> getCredentialStatus(
    Iden3MessageEntity iden3MessageEntity,
  ) async {
    emit(state.loading());
    final mnemonic =
        await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

    final claimEntities = await polygonIdCubit.getClaimsFromIden3Message(
      iden3MessageEntity: iden3MessageEntity,
      mnemonic: mnemonic!,
    );

    bool canGenerateProof = false;

    for (final claimEntity in claimEntities) {
      if (claimEntity != null) {
        canGenerateProof = true;
      }
    }

    emit(
      state.copyWith(
        claimEntities: claimEntities,
        status: AppStatus.idle,
        canGenerateProof: canGenerateProof,
      ),
    );
  }
}
