import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:secure_storage/secure_storage.dart';

part 'did_state.dart';

part 'did_cubit.g.dart';

class DIDCubit extends Cubit<DIDState> {
  DIDCubit({required this.didKitProvider, required this.secureStorageProvider})
      : super(const DIDState());

  final SecureStorageProvider secureStorageProvider;
  final DIDKitProvider didKitProvider;

  Future<void> set({
    required String did,
    required String didMethod,
    required String didMethodName,
    required String verificationMethod,
  }) async {
    final log = Logger('altme-wallet/DID/set');

    emit(state.loading());
    await secureStorageProvider.set(SecureStorageKeys.did, did);
    await secureStorageProvider.set(SecureStorageKeys.didMethod, didMethod);
    await secureStorageProvider.set(
      SecureStorageKeys.verificationMethod,
      verificationMethod,
    );
    await secureStorageProvider.set(
      SecureStorageKeys.didMethodName,
      didMethodName,
    );

    emit(
      state.success(
        did: did,
        didMethod: didMethod,
        didMethodName: didMethodName,
      ),
    );

    log.info('successfully Set');
  }

  Future<void> load({
    required String did,
    required String didMethod,
    required String didMethodName,
  }) async {
    final log = Logger('altme-wallet/DID/load');
    emit(state.loading());
    emit(
      state.success(
        did: did,
        didMethod: didMethod,
        didMethodName: didMethodName,
      ),
    );
    log.info('successfully Loaded');
  }
}
