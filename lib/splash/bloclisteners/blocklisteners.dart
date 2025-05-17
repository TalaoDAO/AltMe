import 'dart:async';
import 'dart:convert';

import 'package:altme/ai/widget/ai_request_analysis_button.dart';
import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/enterprise/enterprise.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/helper_function/get_issuance_data.dart';
import 'package:altme/oidc4vc/helper_function/oidc4vci_accept_host.dart';
import 'package:altme/oidc4vc/helper_function/oidc4vp_siopv2_accept_host.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/route/route.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

final splashBlocListener = BlocListener<SplashCubit, SplashState>(
  listener: (BuildContext context, SplashState state) {
    if (state.status == SplashStatus.routeToPassCode) {
      securityCheck(
        context: context,
        title: context.l10n.typeYourPINCodeToOpenTheWallet,
        localAuthApi: LocalAuthApi(),
        onSuccess: () {
          Navigator.of(context).push<void>(DashboardPage.route());
          context.read<SplashCubit>().authenticated();
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

final ProfileCubitListener = BlocListener<ProfileCubit, ProfileState>(
  listener: (BuildContext context, ProfileState state) {
    if (state.status == AppStatus.addEuropeanProfile) {
      context.read<CredentialsCubit>().addWalletCredential(
            qrCodeScanCubit: context.read<QRCodeScanCubit>(),
            profileLinkedId: ProfileType.europeanWallet.getVCId,
          );
    }
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
        Navigator.popUntil(
          context,
          (route) => route.settings.name == AltMeStrings.dashBoardPage,
        );
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
      if (Parameters.walletHandlesCrypto) {
        unawaited(context.read<TokensCubit>().fetchFromZero());
        unawaited(context.read<NftCubit>().fetchFromZero());
      }
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
      final client =
          DioClient(secureStorageProvider: getSecureStorage, dio: Dio());

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
          final oidc4vc = OIDC4VC();

          var acceptHost = true;
          final approvedIssuer = Issuer.emptyIssuer(state.uri!.host);

          final profileSetting = profileCubit.state.model.profileSetting;

          final walletSecurityOptions = profileSetting.walletSecurityOptions;

          final bool verifySecurityIssuerWebsiteIdentity =
              walletSecurityOptions.verifySecurityIssuerWebsiteIdentity;
          final bool confirmSecurityVerifierAccess =
              walletSecurityOptions.confirmSecurityVerifierAccess;

          final bool showPrompt = verifySecurityIssuerWebsiteIdentity ||
              confirmSecurityVerifierAccess;

          final bool isOpenIDUrl = isOIDC4VCIUrl(state.uri!);
          final bool isPresentation = isSIOPV2OROIDC4VPUrl(state.uri!);
          final bool isFromDeeplink = state.uri
                  .toString()
                  .startsWith(Parameters.authorizeEndPoint) ||
              state.uri.toString().startsWith(Parameters.oidc4vcUniversalLink);

          OIDC4VCType? oidc4vcTypeForIssuance;
          dynamic credentialOfferJsonForIssuance;
          OpenIdConfiguration? openIdConfiguration;
          String? issuerForIssuance;
          String? preAuthorizedCodeForIssuance;

          if (isPresentation) {
            await oidc4vpSiopV2AcceptHost(
              uri: state.uri!,
              context: context,
              isDeveloperMode: profileCubit.state.model.isDeveloperMode,
              client: client,
              showPrompt: showPrompt,
              approvedIssuer: approvedIssuer,
            );
            return;
          }
          if (isOpenIDUrl || isFromDeeplink) {
            final Oidc4vcParameters oidc4vcParameters = await getIssuanceData(
              url: state.uri.toString(),
              client: client,
              oidc4vc: oidc4vc,
              oidc4vciDraftType: profileSetting.selfSovereignIdentityOptions
                  .customOidc4vcProfile.oidc4vciDraft,
              useOAuthAuthorizationServerLink:
                  useOauthServerAuthEndPoint(profileCubit.state.model),
            );
            await oidc4vciAcceptHost(
              oidc4vcParameters: oidc4vcParameters,
              context: context,
              isDeveloperMode: profileCubit.state.model.isDeveloperMode,
              client: client,
              showPrompt: verifySecurityIssuerWebsiteIdentity,
              approvedIssuer: approvedIssuer,
            );
            return;
          } else {
            if (showPrompt && verifySecurityIssuerWebsiteIdentity) {
              final String title = l10n.scanPromptHost;

              final String subtitle = (approvedIssuer.did.isEmpty)
                  ? state.uri!.host
                  : '''${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}''';

              LoadingView().hide();
              acceptHost = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDialog(
                        title: title,
                        subtitle: subtitle,
                        yes: l10n.communicationHostAllow,
                        no: l10n.communicationHostDeny,
                      );
                    },
                  ) ??
                  false;
            }
            LoadingView().hide();
            if (acceptHost) {
              await context.read<QRCodeScanCubit>().accept(
                    approvedIssuer: approvedIssuer,
                    qrCodeScanCubit: context.read<QRCodeScanCubit>(),
                    oidcType: oidc4vcTypeForIssuance,
                    credentialOfferJson: credentialOfferJsonForIssuance,
                    openIdConfiguration: openIdConfiguration,
                    issuer: issuerForIssuance,
                    preAuthorizedCode: preAuthorizedCodeForIssuance,
                    uri: state.uri!,
                  );
            } else {
              context.read<QRCodeScanCubit>().emitError(
                    error: ResponseMessage(
                      message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
                    ),
                    callToAction: AiRequestAnalysisButton(
                      link: state.uri!.toString(),
                    ),
                  );
              return;
            }
          }
        }
      }

      if (state.status == QrScanStatus.authorizationFlow) {
        try {
          if (state.uri != null) {
            LoadingView().show(context: context);
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

            await context.read<QRCodeScanCubit>().authorizedFlowCompletion(
                  statePayload: statePayload,
                  codeForAuthorisedFlow: codeForAuthorisedFlow,
                  qrCodeScanCubit: context.read<QRCodeScanCubit>(),
                );
          }
        } catch (e) {
          context.read<QRCodeScanCubit>().emitError(error: e);
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
            title: l10n.typeYourPINCodeToAuthenticate,
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

      if (state.status == QrScanStatus.pauseForDialog) {
        LoadingView().hide();

        final data = state.dialogData ?? '';

        final bool moveAhead = await showDialog<bool>(
              context: context,
              builder: (_) {
                return DeveloperModeDialog(
                  onDisplay: () async {
                    final returnedValue =
                        await Navigator.of(context).push<dynamic>(
                      JsonViewerPage.route(
                        title: l10n.display,
                        data: data,
                      ),
                    );

                    if (returnedValue != null &&
                        returnedValue is bool &&
                        returnedValue) {
                      Navigator.of(context).pop(true);
                    }

                    return;
                  },
                  onSkip: () {
                    Navigator.of(context).pop(true);
                  },
                );
              },
            ) ??
            true;

        context.read<QRCodeScanCubit>().completer?.complete(moveAhead);
        LoadingView().show(context: context);
      }

      if (state.status == QrScanStatus.pauseForDisplay) {
        LoadingView().hide();

        final data = state.dialogData ?? '';

        final returnedValue = await Navigator.of(context).push<dynamic>(
          JsonViewerPage.route(
            title: l10n.display,
            data: data,
          ),
        );

        var moveAhead = false;

        if (returnedValue != null && returnedValue is bool && returnedValue) {
          moveAhead = true;
        }

        context.read<QRCodeScanCubit>().completer?.complete(moveAhead);
        LoadingView().show(context: context);
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
      context.read<QRCodeScanCubit>().emitError(error: e);
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

        final incomingNetworkType = beaconRequest.request!.network!.type!.name;
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

final enterpriseBlocListener = BlocListener<EnterpriseCubit, EnterpriseState>(
  listener: (BuildContext context, EnterpriseState state) async {
    if (state.status == AppStatus.loading) {
      LoadingView().show(context: context);
    }

    if (state.status == AppStatus.goBack) {
      Navigator.of(context).pop();
      LoadingView().hide();
    }

    if (state.status == AppStatus.revoked) {
      LoadingView().hide();
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const WalletRevokedDialog(),
      );
    }
    if (state.status == AppStatus.successAdd) {
      // TODO(hawkbee): when we create vc+sd-jwt associated address cards
      // we need to check also for vc+sd-jwt
      if (context
              .read<ProfileCubit>()
              .state
              .model
              .profileSetting
              .blockchainOptions
              ?.associatedAddressFormat ==
          VCFormatType.ldpVc) {
        // get list of crypto accounts from profile cubit
        final manageAccountsCubit = ManageAccountsCubit(
          credentialsCubit: context.read<CredentialsCubit>(),
          manageNetworkCubit: context.read<ManageNetworkCubit>(),
        );
        final cryptoAccounts = manageAccountsCubit.state.cryptoAccount.data;
        // generate crypto accounts cards
        await context.read<CredentialsCubit>().generateCryptoAccountsCards(
              cryptoAccounts,
            );
      }
    }
    if (state.status == AppStatus.addEnterpriseAccount ||
        state.status == AppStatus.updateEnterpriseAccount ||
        state.status == AppStatus.replaceEnterpriseAccount) {
      final settingJson = state.profileSettingJson;
      if (settingJson != null) {
        final l10n = context.l10n;
        final profileSetting = ProfileSetting.fromJson(
          jsonDecode(settingJson) as Map<String, dynamic>,
        );

        var title = l10n.approveProfileTitle;
        var subTitle = l10n.approveProfileDescription(
          profileSetting.generalOptions.companyName,
        );

        if (state.status == AppStatus.updateEnterpriseAccount) {
          title = l10n.updateProfileTitle;
          subTitle = l10n.updateProfileDescription(
            profileSetting.generalOptions.companyName,
          );
        }

        if (state.status == AppStatus.replaceEnterpriseAccount) {
          title = l10n.replaceProfileTitle;
          subTitle = l10n.replaceProfileDescription(
            profileSetting.generalOptions.companyName,
          );
        }
        LoadingView().hide();

        final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => ConfirmDialog(
                title: title,
                subtitle: subTitle,
                yes: l10n.showDialogYes,
                no: l10n.showDialogNo,
              ),
            ) ??
            false;

        if (confirm) {
          await context.read<EnterpriseCubit>().applyConfiguration(
                qrCodeScanCubit: context.read<QRCodeScanCubit>(),
                manageNetworkCubit: context.read<ManageNetworkCubit>(),
                status: state.status,
              );
        } else {
          /// Need to remove the enterprise email from secure storage
          /// because we may think later that the entreprise profile is
          /// already installed.
          await getSecureStorage.delete(
            SecureStorageKeys.enterpriseEmail,
          );
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
