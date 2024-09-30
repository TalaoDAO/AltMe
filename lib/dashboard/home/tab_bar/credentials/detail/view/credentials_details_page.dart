// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/selective_disclosure/widget/display_selective_disclosure.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:share_plus/share_plus.dart';

class CredentialsDetailsPage extends StatelessWidget {
  const CredentialsDetailsPage({
    super.key,
    required this.credentialModel,
    required this.readOnly,
    required this.cardChatSupportCubit,
  });

  final CredentialModel credentialModel;
  final bool readOnly;
  final CardChatSupportCubit? cardChatSupportCubit;

  static Route<dynamic> route({
    required CredentialModel credentialModel,
    CardChatSupportCubit? cardChatSupportCubit,
    bool readOnly = false,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => CredentialsDetailsPage(
        credentialModel: credentialModel,
        readOnly: readOnly,
        cardChatSupportCubit: cardChatSupportCubit,
      ),
      settings: const RouteSettings(name: '/credentialsDetailsPages'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CredentialDetailsCubit>(
          create: (context) => CredentialDetailsCubit(
            didKitProvider: DIDKitProvider(),
            secureStorageProvider: getSecureStorage,
            client: DioClient(
              secureStorageProvider: getSecureStorage,
              dio: Dio(),
            ),
            jwtDecode: JWTDecode(),
            profileCubit: context.read<ProfileCubit>(),
            polygonIdCubit: context.read<PolygonIdCubit>(),
          ),
        ),
        if (cardChatSupportCubit != null)
          BlocProvider<CardChatSupportCubit>.value(
            value: cardChatSupportCubit!,
          ),
      ],
      child: CredentialsDetailsView(
        credentialModel: credentialModel,
        cardChatSupportCubit: cardChatSupportCubit,
      ),
    );
  }
}

class CredentialsDetailsView extends StatefulWidget {
  const CredentialsDetailsView({
    super.key,
    required this.credentialModel,
    required this.cardChatSupportCubit,
  });

  final CredentialModel credentialModel;
  final CardChatSupportCubit? cardChatSupportCubit;

  @override
  _CredentialsDetailsViewState createState() => _CredentialsDetailsViewState();
}

class _CredentialsDetailsViewState extends State<CredentialsDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<CredentialDetailsCubit>()
          .verifyCredential(widget.credentialModel);
    });
  }

  Future<void> delete() async {
    final l10n = context.l10n;
    final confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
              title: l10n.credentialDetailDeleteConfirmationDialog,
              yes: l10n.credentialDetailDeleteConfirmationDialogYes,
              no: l10n.credentialDetailDeleteConfirmationDialogNo,
            );
          },
        ) ??
        false;

    if (confirm) {
      final credentialsCubit = context.read<CredentialsCubit>();
      await credentialsCubit.deleteById(
        id: widget.credentialModel.id,
        blockchainType:
            context.read<WalletCubit>().state.currentAccount!.blockchainType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final outputDescriptors =
        widget.credentialModel.credentialManifest?.outputDescriptors;

    final profileData = context.read<ProfileCubit>().state.model;

    final isDeveloperMode = profileData.isDeveloperMode;

    final credentialManifestSupport = profileData
        .profileSetting
        .selfSovereignIdentityOptions
        .customOidc4vcProfile
        .credentialManifestSupport;

    final credentialSupported = widget.credentialModel.credentialSupported;

    final claims = credentialSupported?['claims'];
    final containClaims = claims != null;

    String? credentialImage;

    if (containClaims) {
      credentialImage = SelectiveDisclosure(widget.credentialModel).getPicture;
    }

    final credentialSubjectType = widget.credentialModel.credentialPreview
        .credentialSubjectModel.credentialSubjectType;

    final showVerticalDescription =
        credentialSubjectType == CredentialSubjectType.eudiPid ||
            credentialSubjectType == CredentialSubjectType.identityCredential ||
            credentialSubjectType == CredentialSubjectType.verifiableIdCard;

    return BlocConsumer<CredentialDetailsCubit, CredentialDetailsState>(
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
        final List<Activity> activities =
            List<Activity>.from(widget.credentialModel.activities);

        final List<Activity> reversedList =
            List<Activity>.from(activities.reversed);

        if (activities.isNotEmpty) {
          reversedList.insert(0, activities[0]);
          reversedList.removeLast();
        }

        final profileSetting =
            context.read<ProfileCubit>().state.model.profileSetting;

        return BasePage(
          title: l10n.cardDetails,
          titleAlignment: Alignment.topCenter,
          titleLeading: const BackLeadingButton(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollView: false,
          body: Column(
            children: [
              Expanded(
                child: BackgroundCard(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (credentialImage != null)
                          PictureDisplay(credentialImage: credentialImage)
                        else
                          CredentialDisplay(
                            credentialModel: widget.credentialModel,
                            credDisplayType: CredDisplayType.Detail,
                            profileSetting: profileSetting,
                            isDiscover: false,
                          ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CredentialDetailTabbar(
                                    isSelected: state
                                            .credentialDetailTabStatus ==
                                        CredentialDetailTabStatus.informations,
                                    title: l10n.credentialManifestInformations,
                                    onTap: () => context
                                        .read<CredentialDetailsCubit>()
                                        .changeTabStatus(
                                          CredentialDetailTabStatus
                                              .informations,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: CredentialDetailTabbar(
                                    isSelected:
                                        state.credentialDetailTabStatus ==
                                            CredentialDetailTabStatus.activity,
                                    title: l10n.credentialDetailsActivity,
                                    onTap: () => context
                                        .read<CredentialDetailsCubit>()
                                        .changeTabStatus(
                                          CredentialDetailTabStatus.activity,
                                        ),
                                  ),
                                ),
                                if (widget.cardChatSupportCubit != null)
                                  Expanded(
                                    child: StreamBuilder(
                                      stream: context
                                          .read<CardChatSupportCubit>()
                                          .unreadMessageCountStream,
                                      builder: (context, snapShot) {
                                        return CredentialDetailTabbar(
                                          isSelected: false,
                                          badgeCount: snapShot.data ?? 0,
                                          title: l10n.chat,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              LoyaltyCardSupportChatPage.route(
                                                chatWelcomeMessage:
                                                    l10n.cardChatWelcomeMessage,
                                                appBarTitle:
                                                    '${l10n.chatWith} ${widget.credentialModel.credentialPreview.credentialSubjectModel.offeredBy?.name}',
                                                cardChatSupportCubit: widget
                                                    .cardChatSupportCubit!,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            Divider(
                              height: 0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHigh,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (state.credentialDetailTabStatus ==
                            CredentialDetailTabStatus.informations) ...[
                          /// active status
                          if (state.credentialStatus !=
                              CredentialStatus.noStatus) ...[
                            const SizedBox(height: 10),
                            CredentialActiveStatus(
                              credentialStatus: state.credentialStatus,
                            ),
                          ],

                          /// credential manifest details
                          if (credentialManifestSupport &&
                              outputDescriptors != null) ...[
                            CredentialManifestDetails(
                              outputDescriptor: outputDescriptors.firstOrNull,
                              credentialModel: widget.credentialModel,
                            ),
                          ],

                          /// display widget
                          if (!credentialManifestSupport &&
                              widget.credentialModel.display != null &&
                              !isDeveloperMode) ...[
                            const SizedBox(height: 10),
                            DisplayWidget(
                              display: widget.credentialModel.display!,
                            ),
                          ],

                          /// credentialSubjectData
                          CredentialSubjectData(
                            credentialModel: widget.credentialModel,
                            showVertically: showVerticalDescription,
                          ),

                          /// selective disclouse data - _sd
                          /// and normal data too
                          if (!isDeveloperMode)
                            DisplaySelectiveDisclosure(
                              credentialModel: widget.credentialModel,
                              claims: null,
                              showVertically: showVerticalDescription,
                            ),

                          // /// normal claims data
                          // if (widget.credentialModel.credentialSupported !=
                          //         null &&
                          //     widget.credentialModel.credentialSupported!
                          //         .containsKey('claims')) ...[
                          //   NormalClaimsData(
                          //     credentialModel: widget.credentialModel,
                          //   ),
                          // ],

                          //// wallet attestation data
                          if (widget.credentialModel.credentialPreview
                                  .credentialSubjectModel
                              is WalletCredentialModel) ...[
                            WalletCredentialetailsWidget(
                              credentialModel: widget.credentialModel,
                            ),
                          ],

                          /// developer mode data
                          if (widget.credentialModel.pendingInfo == null &&
                              isDeveloperMode) ...[
                            DeveloperDetails(
                              credentialModel: widget.credentialModel,
                              showVertically: showVerticalDescription,
                              statusListIndex: state.statusListIndex,
                              statusListUri: state.statusListUrl,
                            ),
                          ],

                          /// deferred credential data
                          if (widget.credentialModel.pendingInfo != null) ...[
                            DeferredCredentialData(
                              credentialModel: widget.credentialModel,
                              showVertically: showVerticalDescription,
                            ),
                          ],
                        ],
                        if (state.credentialDetailTabStatus ==
                            CredentialDetailTabStatus.activity) ...[
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: reversedList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ActivityWidget(
                                activity: reversedList[index],
                                showVertically: showVerticalDescription,
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          navigation: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyOutlinedButton(
                    onPressed:
                        widget.credentialModel.disAllowDelete ? null : delete,
                    text: l10n.credentialDetailDeleteCard,
                  ),
                  const SizedBox(height: 8),
                  if (widget.credentialModel.pendingInfo == null) ...[
                    if (isDeveloperMode)
                      MyOutlinedButton(
                        text: l10n.download,
                        onPressed: () {
                          if (widget.credentialModel.isEbsiCard) {
                            /// removing type that was added in add_ebsi_credential.dart
                            widget.credentialModel.data['credentialSubject']
                                .remove('type');
                          }

                          late String data;
                          final String? jwt = widget.credentialModel.jwt;
                          if (jwt != null) {
                            data = jwt;
                          } else {
                            data = jsonEncode(widget.credentialModel.data);
                          }

                          getLogger(
                            'CredentialDetailsPage - shared date',
                          ).i(data);

                          final box = context.findRenderObject() as RenderBox?;
                          final subject = l10n.shareWith;

                          Share.share(
                            data,
                            subject: subject,
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                      ),
                  ] else ...[
                    MyOutlinedButton(
                      text: l10n.getItNow,
                      onPressed: () {
                        Navigator.of(context).pop();
                        context
                            .read<QRCodeScanCubit>()
                            .startOIDC4VCDeferedCredentialIssuance(
                              credentialModel: widget.credentialModel,
                              qrCodeScanCubit: context.read<QRCodeScanCubit>(),
                            );
                      },
                    ),
                  ],
                  if (widget.credentialModel.shareLink != '')
                    MyOutlinedButton.icon(
                      icon: SvgPicture.asset(
                        IconStrings.qrCode,
                        width: 24,
                        height: 24,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        Navigator.of(context).push<void>(
                          QrCodeDisplayPage.route(
                            title: '',
                            data: widget.credentialModel.shareLink,
                          ),
                        );
                      },
                      text: l10n.credentialDetailShare,
                    )
                  else
                    Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
