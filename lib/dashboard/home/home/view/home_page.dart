import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _onStartPassBaseVerification() async {
    final pinCode = await getSecureStorage.get(SecureStorageKeys.pinCode);
    if (pinCode?.isEmpty ?? true) {
      context
          .read<HomeCubit>()
          .startPassbaseVerification(context.read<WalletCubit>());
    } else {
      await Navigator.of(context).push<void>(
        PinCodePage.route(
          isValidCallback: () => context
              .read<HomeCubit>()
              .startPassbaseVerification(context.read<WalletCubit>()),
          restrictToBack: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, homeState) {
        if (homeState.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (homeState.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: homeState.message!,
          );
        }

        if (homeState.passBaseStatus == PassBaseStatus.declined) {
          showDialog<void>(
            context: context,
            builder: (_) => DefaultDialog(
              title: l10n.verificationDeclinedTitle,
              description: l10n.verificationDeclinedDescription,
              buttonLabel: l10n.restartVerification.toUpperCase(),
              onButtonClick: _onStartPassBaseVerification,
            ),
          );
        }

        if (homeState.passBaseStatus == PassBaseStatus.pending) {
          showDialog<void>(
            context: context,
            builder: (_) => DefaultDialog(
              title: l10n.verificationPendingTitle,
              description: l10n.verificationPendingDescription,
            ),
          );
        }

        if (homeState.passBaseStatus == PassBaseStatus.undone) {
          showDialog<void>(
            context: context,
            builder: (_) => KycDialog(
              startVerificationPressed: _onStartPassBaseVerification,
            ),
          );
        }

        if (homeState.status == AppStatus.success) {
          showDialog<void>(
            context: context,
            builder: (_) => const FinishKycDialog(),
          );
        }
      },
      child: const TabControllerPage(),
    );
  }
}
