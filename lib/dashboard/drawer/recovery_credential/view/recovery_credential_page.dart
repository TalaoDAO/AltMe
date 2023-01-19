import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/recovery_credential/recovery_credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class RecoveryCredentialPage extends StatelessWidget {
  const RecoveryCredentialPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const RecoveryCredentialPage(),
        settings: const RouteSettings(name: '/recoveryCredentialPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecoveryCredentialCubit(
        walletCubit: context.read<WalletCubit>(),
        cryptoKeys: const CryptocurrencyKeys(),
        secureStorageProvider: getSecureStorage,
      ),
      child: const RecoveryCredentialView(),
    );
  }
}

class RecoveryCredentialView extends StatefulWidget {
  const RecoveryCredentialView({Key? key}) : super(key: key);

  @override
  _RecoveryCredentialViewState createState() => _RecoveryCredentialViewState();
}

class _RecoveryCredentialViewState extends State<RecoveryCredentialView> {
  late TextEditingController mnemonicController;

  @override
  void initState() {
    super.initState();
    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      context
          .read<RecoveryCredentialCubit>()
          .isMnemonicsValid(mnemonicController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.restoreCredential,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.only(
        top: 0,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        bottom: Sizes.spaceSmall,
      ),
      body: BlocConsumer<RecoveryCredentialCubit, RecoveryCredentialState>(
        listener: (context, state) {
          if (state.status == AppStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }

          if (state.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const MStepper(
                totalStep: 2,
                step: 1,
              ),
              const SizedBox(
                height: Sizes.spaceNormal,
              ),
              Text(
                l10n.restoreCredentialStep1Title,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle3,
              ),
              const SizedBox(height: 32),
              BaseTextField(
                hint: l10n.restorePhraseTextFieldHint,
                fillColor: Colors.transparent,
                hintStyle: Theme.of(context).textTheme.hintTextFieldStyle,
                controller: mnemonicController,
                error: state.isTextFieldEdited && !state.isMnemonicValid
                    ? l10n.recoveryMnemonicError
                    : null,
                height: 160,
                borderRadius: Sizes.normalRadius,
                maxLines: 10,
              ),
            ],
          );
        },
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: BlocBuilder<RecoveryCredentialCubit, RecoveryCredentialState>(
          builder: (context, state) {
            return MyGradientButton(
              onPressed: !state.isMnemonicValid
                  ? null
                  : () async {
                      LoadingView().show(context: context);
                      await getSecureStorage.delete(
                        SecureStorageKeys.recoverCredentialMnemonics,
                      );
                      await getSecureStorage.set(
                        SecureStorageKeys.recoverCredentialMnemonics,
                        mnemonicController.text,
                      );
                      LoadingView().hide();
                      await Navigator.of(context).push<void>(
                        UploadRecoveryCredentialPage.route(
                          recoveryCredentialCubit:
                              context.read<RecoveryCredentialCubit>(),
                        ),
                      );
                    },
              text: l10n.next,
            );
          },
        ),
      ),
    );
  }
}
