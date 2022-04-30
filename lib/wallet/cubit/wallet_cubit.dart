import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/drawer/drawer.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'wallet_cubit.g.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({
    required this.repository,
    required this.secureStorageProvider,
    required this.profileCubit,
  }) : super(WalletState()) {
    initialize();
  }

  final CredentialsRepository repository;
  final SecureStorageProvider secureStorageProvider;
  final ProfileCubit profileCubit;

  Future initialize() async {
    final key = await secureStorageProvider.get('key');
    if (key != null) {
      if (key.isNotEmpty) {
        /// When app is initialized, set all credentials with active status to
        /// unknown status
        await repository.initializeRevocationStatus();

        /// load all credentials from repository
        await repository.findAll(/* filters */).then((values) {
          emit(state.copyWith(status: WalletStatus.init, credentials: values));
        });
      }
    }
  }

  Future deleteById(String id) async {
    await repository.deleteById(id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == id);
    emit(state.copyWith(status: WalletStatus.delete, credentials: credentials));
  }

  Future updateCredential(CredentialModel credential) async {
    await repository.update(credential);
    final index =
        state.credentials.indexWhere((element) => element.id == credential.id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == credential.id)
      ..insert(index, credential);
    emit(state.copyWith(status: WalletStatus.update, credentials: credentials));
  }

  Future handleUnknownRevocationStatus(CredentialModel credential) async {
    await repository.update(credential);
    final index =
        state.credentials.indexWhere((element) => element.id == credential.id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == credential.id)
      ..insert(index, credential);
    emit(state.copyWith(status: WalletStatus.idle, credentials: credentials));
  }

  Future insertCredential(CredentialModel credential) async {
    await repository.insert(credential);
    final credentials = List.of(state.credentials)..add(credential);
    emit(state.copyWith(status: WalletStatus.insert, credentials: credentials));
  }

  Future resetWallet() async {
    await secureStorageProvider.delete(SecureStorageKeys.key);
    await secureStorageProvider.delete(SecureStorageKeys.mnemonic);
    await secureStorageProvider.delete(SecureStorageKeys.data);
    await repository.deleteAll();
    await profileCubit.resetProfile();
    emit(state.copyWith(status: WalletStatus.reset, credentials: []));
    emit(state.copyWith(status: WalletStatus.init));
  }

  Future<void> recoverWallet(List<CredentialModel> credentials) async {
    await repository.deleteAll();
    credentials
        .forEach((credential) async => await repository.insert(credential));
    emit(state.copyWith(status: WalletStatus.init, credentials: credentials));
  }
}
