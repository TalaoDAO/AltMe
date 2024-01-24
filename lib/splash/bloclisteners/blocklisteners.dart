import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/route/route.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:polygonid/polygonid.dart';
import 'package:share_plus/share_plus.dart';

final splashBlocListener = BlocListener<SplashCubit, SplashState>(
  listener: (BuildContext context, SplashState state) {
    if (state.status == SplashStatus.routeToPassCode) {
      securityCheck(
        context: context,
        localAuthApi: LocalAuthApi(),
        onSuccess: () {
          Navigator.of(context).push<void>(DashboardPage.route());
        },
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

final credentialsBlocListener =
    BlocListener<CredentialsCubit, CredentialsState>(
  listener: (BuildContext context, CredentialsState state) async {
    if (state.status == CredentialsStatus.idle) {
      if (state.message != null) {
        AlertMessage.showStateMessage(
          context: context,
          stateMessage: state.message!,
        );
      }
      return;
    }

    if (state.status == CredentialsStatus.loading) {
      LoadingView().show(context: context);
    } else {
      /// during onBoarding
      final onboardingState = context.read<OnboardingCubit>();
      if (onboardingState.state.status != AppStatus.loading) {
        LoadingView().hide();
      }
    }

    if (state.message != null &&
        (state.status == CredentialsStatus.error ||
            state.status == CredentialsStatus.insert ||
            state.status == CredentialsStatus.delete ||
            state.status == CredentialsStatus.update)) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: state.message!,
      );
    }
    if (state.status == CredentialsStatus.delete) {
      if (state.message != null) {
        Navigator.of(context).pop();
      }
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
    try {
      await context.read<ManageNetworkCubit>().loadNetwork();
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
              title: l10n.confimrDIDAuth,
              yes: l10n.showDialogYes,
              no: l10n.showDialogNo,
            ),
          ) ??
          false;

      if (confirm) {
        await scanCubit.getDIDAuthCHAPI(
          done: state.done!,
          uri: state.uri!,
          challenge: state.challenge!,
          domain: state.domain!,
        );
      } else {
        Navigator.of(context).pop();
      }
    }

    if (state.message != null) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: state.message!,
      );
    }

    if (state.status == ScanStatus.success) {
      /// should pop until dashboard. Doing such we don't have to consider
      /// different scanCubit scenarii (DIDAuth, scan or deeplink,
      /// presentaiton, etc...).
      await Navigator.pushAndRemoveUntil<void>(
        context,
        DashboardPage.route(),
        (Route<dynamic> route) => route.isFirst,
      );
    }

    if (state.status == ScanStatus.error) {
      Navigator.of(context).pop();
    }

    if (state.status == ScanStatus.goBack) {
      Navigator.of(context).pop();
    }
  },
);

final qrCodeBlocListener = BlocListener<QRCodeScanCubit, QRCodeScanState>(
  listener: (BuildContext context, QRCodeScanState state) async {
    try {
      final log = getLogger('qrCodeBlocListener');

      final l10n = context.l10n;
      final client = DioClient('', Dio());

      if (state.status == QrScanStatus.loading) {
        LoadingView().show(context: context);
      } else {
        LoadingView().hide();
      }

      if (state.status == QrScanStatus.acceptHost) {
        log.i('accept host');
        LoadingView().show(context: context);
        if (state.uri != null) {
          final profileCubit = context.read<ProfileCubit>();

          var acceptHost = true;
          final approvedIssuer = Issuer.emptyIssuer(state.uri!.host);

          final walletSecurityOptions =
              profileCubit.state.model.profileSetting.walletSecurityOptions;

          final bool verifySecurityIssuerWebsiteIdentity =
              walletSecurityOptions.verifySecurityIssuerWebsiteIdentity;
          final bool confirmSecurityVerifierAccess =
              walletSecurityOptions.confirmSecurityVerifierAccess;

          bool showPrompt = verifySecurityIssuerWebsiteIdentity ||
              confirmSecurityVerifierAccess;

          final bool isOpenIDUrl = isOIDC4VCIUrl(state.uri!);
          final bool isFromDeeplink = state.uri
                  .toString()
                  .startsWith(Parameters.authorizeEndPoint) ||
              state.uri.toString().startsWith(Parameters.oidc4vcUniversalLink);

          OIDC4VCType? oidc4vcTypeForIssuance;

          if (isOpenIDUrl || isFromDeeplink) {
            final (
              OIDC4VCType? oidc4vcType,
              OpenIdConfiguration? openIdConfiguration,
              OpenIdConfiguration? authorizationServerConfiguration,
              dynamic credentialOfferJson,
            ) = await getIssuanceData(
              url: state.uri.toString(),
              client: client,
              oidc4vc: OIDC4VC(),
              oidc4vciDraftType: profileCubit
                  .state
                  .model
                  .profileSetting
                  .selfSovereignIdentityOptions
                  .customOidc4vcProfile
                  .oidc4vciDraft,
            );

            oidc4vcTypeForIssuance = oidc4vcType;

            /// if dev mode is ON show some dialog to show data
            if (profileCubit.state.model.isDeveloperMode) {
              late String formattedData;
              if (oidc4vcTypeForIssuance != null) {
                /// issuance case
                formattedData = getFormattedStringOIDC4VCI(
                  url: state.uri.toString(),
                  authorizationServerConfiguration:
                      authorizationServerConfiguration,
                  credentialOfferJson: credentialOfferJson,
                  openIdConfiguration: openIdConfiguration,
                );
              } else {
                var url = state.uri!.toString();

                /// verification case
                final String? requestUri =
                    state.uri!.queryParameters['request_uri'];
                final String? request = state.uri!.queryParameters['request'];

                Map<String, dynamic>? response;

                if (requestUri != null || request != null) {
                  late dynamic encodedData;

                  if (request != null) {
                    encodedData = request;
                  } else if (requestUri != null) {
                    encodedData = await fetchRequestUriPayload(
                      url: requestUri,
                      client: client,
                    );
                  }

                  response = decodePayload(
                    jwtDecode: JWTDecode(),
                    token: encodedData as String,
                  );

                  url = getUpdatedUrlForSIOPV2OIC4VP(
                    uri: state.uri!,
                    response: response,
                  );
                }

                formattedData = await getFormattedStringOIDC4VPSIOPV2(
                  url: url,
                  client: client,
                  response: response,
                );
              }

              LoadingView().hide();
              final bool moveAhead = await showDialog<bool>(
                    context: context,
                    builder: (_) {
                      return DeveloperModeDialog(
                        onDisplay: () async {
                          Navigator.of(context).pop(false);
                          await Navigator.of(context).push<void>(
                            JsonViewerPage.route(
                              title: l10n.display,
                              data: formattedData,
                            ),
                          );
                          return;
                        },
                        onDownload: () {
                          Navigator.of(context).pop(false);

                          final box = context.findRenderObject() as RenderBox?;
                          final subject = l10n.shareWith;

                          Share.share(
                            formattedData,
                            subject: subject,
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                        onSkip: () {
                          Navigator.of(context).pop(true);
                        },
                      );
                    },
                  ) ??
                  true;
              if (!moveAhead) return;
            }

            if (openIdConfiguration != null) {
              await handleErrorForOID4VCI(
                url: state.uri.toString(),
                openIdConfiguration: openIdConfiguration,
                authorizationServerConfiguration:
                    authorizationServerConfiguration,
              );
            }
          }

          if (showPrompt) {
            if (isOpenIDUrl || isFromDeeplink) {
              /// OIDC4VCI Case

              if (oidc4vcTypeForIssuance != null) {
                /// issuance case
                if (!verifySecurityIssuerWebsiteIdentity) showPrompt = false;
              } else {
                /// verification case
                if (!confirmSecurityVerifierAccess) showPrompt = false;
              }
            } else {
              /// normal Case
              if (!verifySecurityIssuerWebsiteIdentity) showPrompt = false;
            }

            if (showPrompt) {
              final String title = l10n.scanPromptHost;

              String subtitle = (approvedIssuer.did.isEmpty)
                  ? state.uri!.host
                  : '''${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}''';

              if (isOpenIDUrl) {
                subtitle = await getHost(
                  uri: state.uri!,
                  client: client,
                );
              }

              LoadingView().hide();
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
          }
          LoadingView().hide();
          if (acceptHost) {
            await context.read<QRCodeScanCubit>().accept(
                  issuer: approvedIssuer,
                  qrCodeScanCubit: context.read<QRCodeScanCubit>(),
                  oidcType: oidc4vcTypeForIssuance,
                );
          } else {
            context.read<QRCodeScanCubit>().emitError(
                  ResponseMessage(
                    message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
                  ),
                );
            return;
          }
        }
      }

      if (state.status == QrScanStatus.authorizationFlow) {
        try {
          if (state.uri != null) {
            LoadingView().show(context: context);
            final profileCubit = context.read<ProfileCubit>();
            final uri = state.uri!;
            final error = uri.queryParameters['error'];
            final errorDescription = uri.queryParameters['error_description'];

            if (error != null) {
              throw ResponseMessage(
                data: {
                  'error': error,
                  'error_description': errorDescription,
                },
              );
            }

            final codeForAuthorisedFlow = uri.queryParameters['code'];
            final stateValue = uri.queryParameters['state'];

            if (codeForAuthorisedFlow == null) {
              throw ResponseMessage(
                data: {
                  'error': 'invalid_request',
                  'error_description': 'The code is missing.',
                },
              );
            }
            if (stateValue == null) {
              throw ResponseMessage(
                data: {
                  'error': 'invalid_request',
                  'error_description': 'The state is missing.',
                },
              );
            }

            await dotenv.load();
            final String authorizationUriSecretKey =
                dotenv.get('AUTHORIZATION_URI_SECRET_KEY');

            final jwt =
                JWT.verify(stateValue, SecretKey(authorizationUriSecretKey));

            final statePayload = jwt.payload as Map<String, dynamic>;

            /// if dev mode is ON show some dialog to show data
            if (profileCubit.state.model.isDeveloperMode) {
              final String formattedData =
                  getFormattedStringOIDC4VCIAuthorizedCodeFlow(
                url: state.uri.toString(),
                codeForAuthorisedFlow: codeForAuthorisedFlow,
                statePayload: statePayload,
              );

              LoadingView().hide();
              final bool moveAhead = await showDialog<bool>(
                    context: context,
                    builder: (_) {
                      return DeveloperModeDialog(
                        onDisplay: () async {
                          Navigator.of(context).pop(false);
                          await Navigator.of(context).push<void>(
                            JsonViewerPage.route(
                              title: l10n.display,
                              data: formattedData,
                            ),
                          );
                          return;
                        },
                        onDownload: () {
                          Navigator.of(context).pop(false);

                          final box = context.findRenderObject() as RenderBox?;
                          final subject = l10n.shareWith;

                          Share.share(
                            formattedData,
                            subject: subject,
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                        onSkip: () {
                          Navigator.of(context).pop(true);
                        },
                      );
                    },
                  ) ??
                  true;
              if (!moveAhead) return;
            }
            await context.read<QRCodeScanCubit>().authorizedFlowCompletion(
                  statePayload: statePayload,
                  codeForAuthorisedFlow: codeForAuthorisedFlow,
                );
          }
        } catch (e) {
          context.read<QRCodeScanCubit>().emitError(e);
        }
      }

      if (state.status == QrScanStatus.siopV2) {
        LoadingView().hide();

        final bool secureSecurityAuthenticationWithPinCode = context
            .read<ProfileCubit>()
            .state
            .model
            .profileSetting
            .walletSecurityOptions
            .secureSecurityAuthenticationWithPinCode;

        if (secureSecurityAuthenticationWithPinCode) {
          /// Authenticate
          bool authenticated = false;
          await securityCheck(
            context: context,
            localAuthApi: LocalAuthApi(),
            onSuccess: () {
              authenticated = true;
            },
          );

          if (!authenticated) {
            return;
          }
        }

        await context.read<QRCodeScanCubit>().completeSiopV2Flow();
      }

      if (state.status == QrScanStatus.success) {
        if (state.route != null) {
          await Navigator.of(context).push<void>(state.route!);
          context.read<QRCodeScanCubit>().clearRoute();
        }
      }

      if (state.message != null) {
        AlertMessage.showStateMessage(
          context: context,
          stateMessage: state.message!,
        );
      }
    } catch (e) {
      if (e.toString().startsWith('Exception: Openid-Configuration-Issue')) {
        context.read<QRCodeScanCubit>().emitError(
              ResponseMessage(
                data: {
                  'error': 'unsupported_format',
                  'error_description': 'Openid configuration response issue.',
                },
              ),
            );
      } else {
        context.read<QRCodeScanCubit>().emitError(e);
      }
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
                message: ResponseString.RESPONSE_STRING_SWITCH_NETWORK_MESSAGE,
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
                message: ResponseString
                    .RESPONSE_STRING_thisFeatureIsNotSupportedMessage,
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
  listener: (BuildContext context, WalletConnectState state) async {
    final log = getLogger('walletConnectStateBlocListener');

    try {
      if (state.status == WalletConnectStatus.permission) {
        await Navigator.of(context).push<void>(
          ConfirmConnectionPage.route(
            connectionBridgeType: ConnectionBridgeType.walletconnect,
          ),
        );
      }

      if (state.status == WalletConnectStatus.signPayload) {
        await Navigator.of(context).push<void>(
          SignPayloadPage.route(
            connectionBridgeType: ConnectionBridgeType.walletconnect,
          ),
        );
      }

      if (state.status == WalletConnectStatus.operation) {
        await Navigator.of(context).push<void>(
          OperationPage.route(
            connectionBridgeType: ConnectionBridgeType.walletconnect,
          ),
        );
      }

      if (state.message != null) {
        AlertMessage.showStateMessage(
          context: context,
          stateMessage: state.message!,
        );
      }
    } catch (e) {
      log.e(e);
    }
  },
);

final polygonIdBlocListener = BlocListener<PolygonIdCubit, PolygonIdState>(
  listener: (BuildContext context, PolygonIdState state) async {
    final polygonIdCubit = context.read<PolygonIdCubit>();

    if (state.status == AppStatus.loading) {
      final MessageHandler? messageHandler = state.loadingText;
      final String? message =
          messageHandler?.getMessage(context, messageHandler);

      LoadingView().show(context: context, text: message);
    } else {
      LoadingView().hide();
    }

    if (state.status == AppStatus.goBack) {
      Navigator.of(context).pop();
    }

    if (state.message != null) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: state.message!,
      );
    }

    if (state.polygonAction == PolygonIdAction.offer) {
      try {
        LoadingView().hide();
        await Navigator.of(context)
            .push<void>(PolygonIdCredentialOfferPage.route());
      } catch (e) {
        final l10n = context.l10n;
        LoadingView().hide();
        AlertMessage.showStateMessage(
          context: context,
          stateMessage: StateMessage.error(
            stringMessage: l10n.somethingsWentWrongTryAgainLater,
          ),
        );
      }
    }

    if (state.polygonAction == PolygonIdAction.verifier) {
      final Iden3MessageEntity iden3MessageEntity =
          await polygonIdCubit.getIden3Message(message: state.scannedResponse!);
      LoadingView().hide();
      await Navigator.of(context).push<void>(
        PolygonIdVerificationPage.route(iden3MessageEntity: iden3MessageEntity),
      );
    }

    if (state.polygonAction == PolygonIdAction.issuer) {
      var accept = true;
      final profileCubit = context.read<ProfileCubit>();

      final bool verifySecurityIssuerWebsiteIdentity = profileCubit
          .state
          .model
          .profileSetting
          .walletSecurityOptions
          .verifySecurityIssuerWebsiteIdentity;

      final l10n = context.l10n;

      if (verifySecurityIssuerWebsiteIdentity) {
        /// checking if it is issuer side

        LoadingView().hide();

        // TODO(all): later choose url based on mainnet and testnet
        accept = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialog(
                  title: l10n.scanPromptHost,
                  subtitle: Urls.checkIssuerPolygonTestnetUrl,
                  no: l10n.communicationHostDeny,
                );
              },
            ) ??
            false;
      }

      LoadingView().hide();

      if (accept) {
        final Iden3MessageEntity iden3MessageEntity = await polygonIdCubit
            .getIden3Message(message: state.scannedResponse!);

        await securityCheck(
          context: context,
          localAuthApi: LocalAuthApi(),
          onSuccess: () {
            context.read<PolygonIdCubit>().authenticateOrGenerateProof(
                  iden3MessageEntity: iden3MessageEntity,
                  isGenerateProof: false,
                );
          },
        );

        return;
      }
    }

    if (state.polygonAction == PolygonIdAction.contractFunctionCall) {
      LoadingView().hide();
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: const StateMessage.error(
          stringMessage: 'This feature is not available yet in our app.',
        ),
      );
    }
  },
);
