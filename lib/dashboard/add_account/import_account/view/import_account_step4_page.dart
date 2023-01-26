import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportAccountStep4Page extends StatelessWidget {
  const ImportAccountStep4Page({
    super.key,
    required this.importAccountCubit,
  });

  final ImportAccountCubit importAccountCubit;

  static Route<dynamic> route({
    required ImportAccountCubit importAccountCubit,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/importAccountStep4Page'),
      builder: (_) => ImportAccountStep4Page(
        importAccountCubit: importAccountCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: importAccountCubit,
      child: const ImportAccountStep4View(),
    );
  }
}

class ImportAccountStep4View extends StatefulWidget {
  const ImportAccountStep4View({super.key});

  @override
  State<ImportAccountStep4View> createState() => _ImportAccountStep4ViewState();
}

class _ImportAccountStep4ViewState extends State<ImportAccountStep4View> {
  late final TextEditingController accountNameTextController;
  late final List<String> accountNameList;

  @override
  void initState() {
    final List<CryptoAccountData> cryptoAccount =
        context.read<WalletCubit>().state.cryptoAccount.data;
    accountNameList = cryptoAccount.map((e) => e.name).toList();
    accountNameTextController = TextEditingController(
      text: generateDefaultAccountName(
        accountNameList.length,
        accountNameList,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<ImportAccountCubit, ImportAccountState>(
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
        if (state.status == AppStatus.success) {
          Navigator.pushReplacement<void, void>(
            context,
            CongratulationsAccountImportPage.route(),
          );
        }
      },
      child: BasePage(
        title: l10n.importAccount,
        titleAlignment: Alignment.topCenter,
        titleLeading: const BackLeadingButton(),
        padding: const EdgeInsets.only(
          top: 0,
          left: Sizes.spaceSmall,
          right: Sizes.spaceSmall,
          bottom: Sizes.spaceSmall,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MStepper(
              totalStep: 4,
              step: 4,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            Text(
              l10n.setAccountNameDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall3,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            BaseTextField(
              controller: accountNameTextController,
              borderRadius: Sizes.smallRadius,
              textCapitalization: TextCapitalization.sentences,
              fillColor: Theme.of(context).highlightColor,
              contentPadding: const EdgeInsets.symmetric(
                vertical: Sizes.spaceSmall,
                horizontal: Sizes.spaceSmall,
              ),
              borderColor: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ],
        ),
        navigation: Padding(
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: BlocBuilder<ImportAccountCubit, ImportAccountState>(
            builder: (context, state) {
              return MyElevatedButton(
                text: l10n.next,
                onPressed: !state.isMnemonicOrKeyValid
                    ? null
                    : () async {
                        await context.read<ImportAccountCubit>().import(
                              accountName: accountNameTextController.text,
                            );
                      },
              );
            },
          ),
        ),
      ),
    );
  }
}
