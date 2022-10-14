import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/pin_code/pin_code.dart';
import 'package:arago_wallet/scan/scan.dart';
import 'package:arago_wallet/splash/splash.dart';
import 'package:arago_wallet/wallet/wallet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final splashBlocListener = BlocListener<SplashCubit, SplashState>(
  listener: (BuildContext context, SplashState state) {
    if (state.status == SplashStatus.routeToPassCode) {
      Navigator.of(context).push<void>(
        PinCodePage.route(
          isValidCallback: () {
            Navigator.of(context).push<void>(DashboardPage.route());
          },
        ),
      );
    }

    if (state.status == SplashStatus.routeToOnboarding) {
      Navigator.of(context).push<void>(DashboardPage.route());
    }
  },
);

final walletBlocListener = BlocListener<WalletCubit, WalletState>(
  listener: (BuildContext context, WalletState state) {
    if (state.message != null) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: state.message!,
      );
    }
    if (state.status == WalletStatus.delete) {
      Navigator.of(context).pop();
    }
    if (state.status == WalletStatus.reset) {
      /// Removes every stack except first route (splashPage)
      Navigator.pushAndRemoveUntil<void>(
        context,
        DashboardPage.route(),
        (Route<dynamic> route) => route.isFirst,
      );
    }
  },
);

final scanBlocListener = BlocListener<ScanCubit, ScanState>(
  listener: (BuildContext context, ScanState state) async {
    final l10n = context.l10n;

    if (state.message != null) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: state.message!,
      );
    }

    if (state.status == ScanStatus.askPermissionDidAuth) {
      final scanCubit = context.read<ScanCubit>();
      final state = scanCubit.state;
      final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => ConfirmDialog(
              title:
                  '''${l10n.credentialPresentTitleDIDAuth}\n\n${l10n.confimrDIDAuth}''',
              yes: l10n.showDialogYes,
              no: l10n.showDialogNo,
            ),
          ) ??
          false;

      if (confirm) {
        await scanCubit.getDIDAuthCHAPI(
          keyId: state.keyId!,
          done: state.done!,
          uri: state.uri!,
          challenge: state.challenge!,
          domain: state.domain!,
        );
      } else {
        Navigator.of(context).pop();
      }
    }
    if (state.status == ScanStatus.success) {
      Navigator.of(context).pop();
    }
    if (state.status == ScanStatus.error) {
      Navigator.of(context).pop();
    }
  },
);

final qrCodeBlocListener = BlocListener<QRCodeScanCubit, QRCodeScanState>(
  listener: (BuildContext context, QRCodeScanState state) async {
    final l10n = context.l10n;

    if (state.status == QrScanStatus.loading) {
      LoadingView().show(context: context);
    } else {
      LoadingView().hide();
    }

    if (state.status == QrScanStatus.acceptHost) {
      if (state.uri != null) {
        final profileCubit = context.read<ProfileCubit>();
        var approvedIssuer = Issuer.emptyIssuer(state.uri!.host);
        final isIssuerVerificationSettingTrue =
            profileCubit.state.model.issuerVerificationUrl != '';
        if (isIssuerVerificationSettingTrue) {
          try {
            approvedIssuer = await CheckIssuer(
              DioClient(Urls.checkIssuerTalaoUrl, Dio()),
              profileCubit.state.model.issuerVerificationUrl,
              state.uri!,
            ).isIssuerInApprovedList();
          } catch (e) {
            if (e is MessageHandler) {
              await context.read<QRCodeScanCubit>().emitError(e);
            } else {
              await context.read<QRCodeScanCubit>().emitError(
                    ResponseMessage(
                      ResponseString
                          .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
                    ),
                  );
            }
            return;
          }
        }

        var acceptHost = true;

        if (approvedIssuer.did.isEmpty) {
          acceptHost = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmDialog(
                    title: l10n.scanPromptHost,
                    subtitle: (approvedIssuer.did.isEmpty)
                        ? state.uri!.host
                        : '''${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}''',
                    yes: l10n.communicationHostAllow,
                    no: l10n.communicationHostDeny,
                    //lock: state.uri!.scheme == 'http',
                  );
                },
              ) ??
              false;
        }

        if (acceptHost) {
          await context.read<QRCodeScanCubit>().accept(
                uri: state.uri!,
                issuer: approvedIssuer,
              );
        } else {
          await context.read<QRCodeScanCubit>().emitError(
                ResponseMessage(
                  ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
                ),
              );
          return;
        }
      }
    }

    if (state.status == QrScanStatus.success) {
      if (state.route != null) {
        if (state.isDeepLink) {
          await Navigator.of(context).push<void>(state.route!);
        } else {
          await Navigator.of(context).pushReplacement<void, void>(state.route!);
        }
      }
    }

    if (state.message != null) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: state.message!,
      );
    }
  },
);
