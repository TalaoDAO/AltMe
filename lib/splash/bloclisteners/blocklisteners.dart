import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/route/route.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      Navigator.of(context).push<void>(StarterPage.route());
    }

    // just for next build -> 117 and then we should remove for build -> 118
    context.read<AdvanceSettingsCubit>().setState(
          Parameters.defaultAdvanceSettingsState,
        );
  },
);

final walletBlocListener = BlocListener<WalletCubit, WalletState>(
  listener: (BuildContext context, WalletState state) async {
    if (state.message != null) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: state.message!,
      );
    }
    if (state.status == WalletStatus.delete) {
      if (state.message != null) {
        Navigator.of(context).pop();
      }
    }
    if (state.status == WalletStatus.reset) {
      /// Removes every stack except first route (splashPage)
      await Navigator.pushAndRemoveUntil<void>(
        context,
        StarterPage.route(),
        (Route<dynamic> route) => route.isFirst,
      );
    }
  },
);

final walletBlocAccountChangeListener = BlocListener<WalletCubit, WalletState>(
  listenWhen: (previous, current) {
    if ((current.currentAccount?.blockchainType != null) &&
        ((previous.currentCryptoIndex != current.currentCryptoIndex) ||
            previous.currentAccount?.blockchainType !=
                current.currentAccount?.blockchainType)) {
      return true;
    } else {
      return false;
    }
  },
  listener: (context, state) async {
    final BlockchainType? blockchainType = state.currentAccount?.blockchainType;
    if (blockchainType == null) return;
    BlockchainNetwork network;
    if (blockchainType == BlockchainType.tezos) {
      network = TezosNetwork.mainNet();
    } else if (blockchainType == BlockchainType.ethereum) {
      network = EthereumNetwork.mainNet();
    } else if (blockchainType == BlockchainType.polygon) {
      network = PolygonNetwork.mainNet();
    } else if (blockchainType == BlockchainType.fantom) {
      network = FantomNetwork.mainNet();
    } else if (blockchainType == BlockchainType.binance) {
      network = BinanceNetwork.mainNet();
    } else {
      network = TezosNetwork.mainNet();
    }
    try {
      await context.read<ManageNetworkCubit>().setNetwork(network);
      unawaited(context.read<TokensCubit>().fetchFromZero());
      unawaited(context.read<NftCubit>().fetchFromZero());
    } catch (e, s) {
      getLogger('BlocListeners: e: $e , s: $s');
    }
  },
);

final scanBlocListener = BlocListener<ScanCubit, ScanState>(
  listener: (BuildContext context, ScanState state) async {
    final l10n = context.l10n;

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

    if (state.message != null) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: state.message!,
      );
    }
  },
);

final qrCodeBlocListener = BlocListener<QRCodeScanCubit, QRCodeScanState>(
  listener: (BuildContext context, QRCodeScanState state) async {
    final log = getLogger('qrCodeBlocListener');

    final l10n = context.l10n;

    if (state.status == QrScanStatus.loading) {
      LoadingView().show(context: context);
    } else {
      LoadingView().hide();
    }

    if (state.status == QrScanStatus.acceptHost) {
      log.i('accept host');
      if (state.uri != null) {
        final profileCubit = context.read<ProfileCubit>();
        var approvedIssuer = Issuer.emptyIssuer(state.uri!.host);

        late bool isIssuerVerificationSettingTrue;

        isIssuerVerificationSettingTrue =
            profileCubit.state.model.issuerVerificationUrl != '';

        /// issuer side (oidc4VCI)
        if (state.uri!.toString().startsWith('openid://initiate_issuance?')) {
          isIssuerVerificationSettingTrue = true;
        }

        /// verifier side (siopv2) without request_uri
        // if (state.uri?.queryParameters['scope'] == 'openid') {
        //   isIssuerVerificationSettingTrue =
        //       state.uri!.queryParameters['request_uri'] != null;
        // }

        /// verifier side (siopv2) with request_uri
        if (state.uri.toString().startsWith('openid://?client_id')) {
          isIssuerVerificationSettingTrue =
              state.uri!.queryParameters['request_uri'] != null;
        }

        log.i('checking issuer - $isIssuerVerificationSettingTrue');

        if (isIssuerVerificationSettingTrue) {
          try {
            approvedIssuer = await CheckIssuer(
              DioClient(Urls.checkIssuerTalaoUrl, Dio()),
              profileCubit.state.model.issuerVerificationUrl,
              state.uri!,
            ).isIssuerInApprovedList();
          } catch (e) {
            log.e(e);
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

        if (approvedIssuer.did.isEmpty && isIssuerVerificationSettingTrue) {
          String subtitle = (approvedIssuer.did.isEmpty)
              ? state.uri!.host
              : '''${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}''';

          /// issuer side (oidc4VCI)
          if (state.uri!.toString().startsWith('openid://initiate_issuance?')) {
            subtitle = state.uri!.queryParameters['issuer'].toString();
          }

          /// verifier side (siopv2) without request_uri
          // if (state.uri?.queryParameters['scope'] == 'openid') {
          //   subtitle = state.uri!.queryParameters['request_uri'].toString();
          // }

          /// verifier side (siopv2) with request_uri
          if (state.uri.toString().startsWith('openid://?client_id')) {
            subtitle = state.uri!.queryParameters['request_uri'].toString();
          }

          String title = l10n.scanPromptHost;

          if (!state.isRequestVerified) {
            title = '${l10n.service_not_registered_message} '
                '${l10n.scanPromptHost}';
          }

          acceptHost = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmDialog(
                    title: title,
                    subtitle: subtitle,
                    yes: l10n.communicationHostAllow,
                    no: l10n.communicationHostDeny,
                    //lock: state.uri!.scheme == 'http',
                  );
                },
              ) ??
              false;
        }

        if (acceptHost) {
          await context.read<QRCodeScanCubit>().accept(issuer: approvedIssuer);
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
        if (state.isScan) {
          await Navigator.of(context).pushReplacement<void, void>(state.route!);
        } else {
          await Navigator.of(context).push<void>(state.route!);
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

final beaconBlocListener = BlocListener<BeaconCubit, BeaconState>(
  listener: (BuildContext context, BeaconState state) {
    final log = getLogger('beaconBlocListener');
    try {
      final BeaconRequest? beaconRequest = state.beaconRequest;

      if (beaconRequest == null) return;

      final Beacon beacon = Beacon();
      final String currenRouteName = context.read<RouteCubit>().state ?? '';

      //signPayload is not network sensitive
      if (state.status != BeaconStatus.signPayload) {
        final manageNetworkCubit = context.read<ManageNetworkCubit>();

        final incomingNetworkType =
            describeEnum(beaconRequest.request!.network!.type!);
        final currentNetworkType =
            manageNetworkCubit.state.network.networkname.toLowerCase();

        // if network type does not match
        if (incomingNetworkType != currentNetworkType) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: StateMessage.error(
              stringMessage: '$incomingNetworkType.',
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_SWITCH_NETWORK_MESSAGE,
              ),
            ),
          );

          final requestId = beaconRequest.request!.id!;

          if (state.status == BeaconStatus.permission) {
            beacon.permissionResponse(
              id: requestId,
              publicKey: null,
              address: null,
            );
            if (currenRouteName == CONFIRM_CONNECTION_PAGE) {
              Navigator.pop(context);
            }
          }

          if (state.status == BeaconStatus.operation) {
            beacon.operationResponse(id: requestId, transactionHash: null);
          }

          return;
        }
      }

      if (state.status == BeaconStatus.permission) {
        sensibleRoute(
          context: context,
          route: ConfirmConnectionPage.route(
            connectionBridgeType: ConnectionBridgeType.beacon,
          ),
          isSameRoute: currenRouteName == CONFIRM_CONNECTION_PAGE,
        );
      }

      if (state.status == BeaconStatus.signPayload) {
        sensibleRoute(
          context: context,
          route: SignPayloadPage.route(
            connectionBridgeType: ConnectionBridgeType.beacon,
          ),
          isSameRoute: currenRouteName == SIGN_PAYLOAD_PAGE,
        );
      }

      if (state.status == BeaconStatus.operation) {
        if (beaconRequest.operationDetails != null &&
            beaconRequest.operationDetails!.isEmpty) {
          beacon.operationResponse(
            id: beaconRequest.request!.id!,
            transactionHash: null,
          );

          return AlertMessage.showStateMessage(
            context: context,
            stateMessage: StateMessage.info(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_thisFeatureIsNotSupportedMessage,
              ),
            ),
          );
        }

        sensibleRoute(
          context: context,
          route: OperationPage.route(
            connectionBridgeType: ConnectionBridgeType.beacon,
          ),
          isSameRoute: currenRouteName == OPERATION_PAGE,
        );
      }
    } catch (e) {
      log.e(e);
    }
  },
);

final walletConnectBlocListener =
    BlocListener<WalletConnectCubit, WalletConnectState>(
  listener: (BuildContext context, WalletConnectState state) {
    final log = getLogger('walletConnectStateBlocListener');
    try {
      if (state.status == WalletConnectStatus.permission) {
        Navigator.of(context).push<void>(
          ConfirmConnectionPage.route(
            connectionBridgeType: ConnectionBridgeType.walletconnect,
          ),
        );
      }

      if (state.status == WalletConnectStatus.signPayload) {
        Navigator.of(context).push<void>(
          SignPayloadPage.route(
            connectionBridgeType: ConnectionBridgeType.walletconnect,
          ),
        );
      }

      if (state.status == WalletConnectStatus.operation) {
        Navigator.of(context).push<void>(
          OperationPage.route(
            connectionBridgeType: ConnectionBridgeType.walletconnect,
          ),
        );
      }
    } catch (e) {
      log.e(e);
    }
  },
);
