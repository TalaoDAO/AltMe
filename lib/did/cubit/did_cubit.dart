import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:secure_storage/secure_storage.dart';

part 'did_cubit.g.dart';

part 'did_state.dart';

class DIDCubit extends Cubit<DIDState> {
  DIDCubit({
    required this.didKitProvider,
    required this.secureStorageProvider,
  }) : super(const DIDState());

  final SecureStorageProvider secureStorageProvider;
  final DIDKitProvider didKitProvider;

  Future<void> set({
    required String did,
    required String didMethod,
    required String didMethodName,
    required String verificationMethod,
  }) async {
    final log = getLogger('DIDCubit - set');

    emit(state.loading());
    await secureStorageProvider.set(SecureStorageKeys.did, did);
    await secureStorageProvider.set(SecureStorageKeys.didMethod, didMethod);
    const didMethodName = AltMeStrings.defaultDIDMethodName;
    await secureStorageProvider.set(
      SecureStorageKeys.didMethodName,
      didMethodName,
    );
    await secureStorageProvider.set(
      SecureStorageKeys.verificationMethod,
      verificationMethod,
    );
    emit(
      state.success(
        did: did,
        didMethod: didMethod,
        didMethodName: didMethodName,
        verificationMethod: verificationMethod,
      ),
    );
    log.i('successfully Set');
  }

  Future<void> load({
    required String did,
    required String didMethod,
    required String didMethodName,
    required String verificationMethod,
  }) async {
    final log = getLogger('DIDCubit - load');
    emit(state.loading());
    emit(
      state.success(
        did: did,
        didMethod: didMethod,
        didMethodName: didMethodName,
        verificationMethod: verificationMethod,
      ),
    );
    log.i('successfully Loaded');
  }
}
