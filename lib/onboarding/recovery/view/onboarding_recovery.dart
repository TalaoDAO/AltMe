import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/recovery/cubit/onboarding_recovery_cubit.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingRecoveryPage extends StatefulWidget {
  const OnBoardingRecoveryPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (context) => OnBoardingRecoveryCubit(
            walletCubit: context.read<WalletCubit>(),
            cryptoKeys: const CryptocurrencyKeys(),
            secureStorageProvider: getSecureStorage,
          ),
          child: const OnBoardingRecoveryPage(),
        ),
        settings: const RouteSettings(name: '/onBoardingKeyPage'),
      );

  static const _padding = EdgeInsets.symmetric(
    horizontal: 16,
  );

  static Widget _padHorizontal(Widget child) => Padding(
        padding: _padding,
        child: child,
      );

  @override
  _OnBoardingRecoveryPageState createState() => _OnBoardingRecoveryPageState();
}

class _OnBoardingRecoveryPageState extends State<OnBoardingRecoveryPage> {
  late TextEditingController mnemonicController;
  late bool buttonEnabled;
  late bool edited;

  @override
  void initState() {
    super.initState();

    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      context
          .read<OnBoardingRecoveryCubit>()
          .isMnemonicsValid(mnemonicController.text);
    });

    edited = false;
    buttonEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.onBoardingRecoveryTitle,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      padding: EdgeInsets.zero,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OnBoardingRecoveryPage._padHorizontal(
            Text(
              l10n.recoveryText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          const SizedBox(height: 24),
          BaseTextField(
            label: l10n.recoveryMnemonicHintText,
            controller: mnemonicController,
            error: edited && !buttonEnabled ? l10n.recoveryMnemonicError : null,
          ),
          const SizedBox(height: 24),
          OnBoardingRecoveryPage._padHorizontal(
            BaseButton.primary(
              context: context,
              onPressed: buttonEnabled
                  ? () async {
                      await context
                          .read<OnBoardingRecoveryCubit>()
                          .saveMnemonic(mnemonicController.text);
                      await Navigator.of(context).pushReplacement<void, void>(
                        ProfilePage.route(
                          isFromOnBoarding: true,
                          profileModel: ProfileModel.empty(),
                        ),
                      );
                    }
                  : null,
              child: Text(l10n.onBoardingRecoveryButton),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
