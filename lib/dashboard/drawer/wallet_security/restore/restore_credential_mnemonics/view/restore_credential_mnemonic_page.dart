import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class RestoreCredentialMnemonicPage extends StatelessWidget {
  const RestoreCredentialMnemonicPage({
    super.key,
    required this.isValidCallback,
    required this.title,
  });

  final VoidCallback isValidCallback;
  final String title;

  static Route<dynamic> route({
    required VoidCallback isValidCallback,
    required String title,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => RestoreCredentialMnemonicPage(
          isValidCallback: isValidCallback,
          title: title,
        ),
        settings: const RouteSettings(name: '/RestoreCredentialMnemonicPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestoreCredentialMnemonicCubit(),
      child: RestoreCredentialMnemonicView(
        isValidCallback: isValidCallback,
        title: title,
      ),
    );
  }
}

class RestoreCredentialMnemonicView extends StatefulWidget {
  const RestoreCredentialMnemonicView({
    super.key,
    required this.isValidCallback,
    required this.title,
  });

  final VoidCallback isValidCallback;
  final String title;

  @override
  _RestoreCredentialMnemonicViewState createState() =>
      _RestoreCredentialMnemonicViewState();
}

class _RestoreCredentialMnemonicViewState
    extends State<RestoreCredentialMnemonicView> {
  late TextEditingController mnemonicController;

  @override
  void initState() {
    super.initState();
    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      context
          .read<RestoreCredentialMnemonicCubit>()
          .isMnemonicsValid(mnemonicController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: widget.title,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.only(
        top: 0,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        bottom: Sizes.spaceSmall,
      ),
      body: BlocConsumer<RestoreCredentialMnemonicCubit,
          RestoreCredentialMnemonicState>(
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
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 32),
              BaseTextField(
                hint: l10n.restorePhraseTextFieldHint,
                fillColor: Colors.transparent,
                hintStyle: Theme.of(context).textTheme.bodyMedium,
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
        child: BlocBuilder<RestoreCredentialMnemonicCubit,
            RestoreCredentialMnemonicState>(
          builder: (context, state) {
            return MyElevatedButton(
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
                      widget.isValidCallback();
                    },
              text: l10n.next,
            );
          },
        ),
      ),
    );
  }
}
