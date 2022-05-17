import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/self_issued_credential_button/cubit/self_issued_credential_button_cubit.dart';
import 'package:altme/self_issued_credential_button/models/self_issued_credential_model.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

typedef SelfIssuedCredentialButtonClick = SelfIssuedCredentialDataModel
    Function();

class SelfIssuedCredentialButton extends StatelessWidget {
  const SelfIssuedCredentialButton({
    Key? key,
    required this.selfIssuedCredentialButtonClick,
  }) : super(key: key);

  final SelfIssuedCredentialButtonClick selfIssuedCredentialButtonClick;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SelfIssuedCredentialCubit>(
      create: (_) => SelfIssuedCredentialCubit(
        walletCubit: context.read<WalletCubit>(),
        secureStorageProvider: secure_storage.getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
      ),
      child: BlocConsumer<SelfIssuedCredentialCubit,
          SelfIssuedCredentialButtonState>(
        listener: (context, state) {
          if (state.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }
        },
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state.status != AppStatus.loading) {
                context
                    .read<SelfIssuedCredentialCubit>()
                    .createSelfIssuedCredential(
                      selfIssuedCredentialDataModel:
                          selfIssuedCredentialButtonClick.call(),
                    );
              }
            },
            child: Builder(
              builder: (_) {
                return state.status == AppStatus.loading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : const Icon(Icons.fact_check_outlined);
              },
            ),
          );
        },
      ),
    );
  }
}
