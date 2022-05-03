import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/key/onboarding_key.dart';
import 'package:altme/onboarding/submit_enterprise_user/view/submit_enterprise_user_page.dart';
import 'package:altme/onboarding/wallet_type/cubit/choose_wallet_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class ChooseWalletTypePage extends StatefulWidget {
  const ChooseWalletTypePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => BlocProvider<ChooseWalletTypeCubit>(
          create: (_) => ChooseWalletTypeCubit(getSecureStorage),
          child: const ChooseWalletTypePage(),
        ),
        settings: const RouteSettings(name: '/onBoardingChooseWalletTypePage'),
      );

  @override
  _ChooseWalletTypePageState createState() => _ChooseWalletTypePageState();
}

class _ChooseWalletTypePageState extends State<ChooseWalletTypePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async => false,
      child: BasePage(
        title: l10n.walletType,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrollView: false,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      l10n.createPersonalWalletTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l10n.createPersonalWalletText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 20),
                    BaseButton.primary(
                      context: context,
                      onPressed: () {
                        context
                            .read<ChooseWalletTypeCubit>()
                            .onChangeWalletType(WalletType.personal);
                        Navigator.of(context)
                            .push<void>(OnBoardingKeyPage.route());
                      },
                      child: Text(l10n.createPersonalWalletButtonTitle),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      l10n.createEnterpriseWalletTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l10n.createEnterpriseWalletText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 20),
                    BaseButton.primary(
                      context: context,
                      onPressed: () {
                        context
                            .read<ChooseWalletTypeCubit>()
                            .onChangeWalletType(WalletType.enterprise);
                        Navigator.of(context)
                            .push<void>(SubmitEnterpriseUserPage.route());
                      },
                      child: Text(l10n.createEnterpriseWalletButtonTitle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
