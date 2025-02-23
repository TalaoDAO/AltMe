import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class HomeCredentialCategoryList extends StatefulWidget {
  const HomeCredentialCategoryList({
    super.key,
    required this.credentials,
    required this.onRefresh,
  });

  final List<CredentialModel> credentials;
  final RefreshCallback onRefresh;

  @override
  State<HomeCredentialCategoryList> createState() =>
      _HomeCredentialCategoryListState();
}

class _HomeCredentialCategoryListState
    extends State<HomeCredentialCategoryList> {
  Future<String> getDid() async {
    final currentAccount = context.read<WalletCubit>().state.currentAccount;
    if (currentAccount == null) {
      return '';
    }
    final didMethod = getDidMethod(currentAccount.blockchainType);

    final String jwkKey = await KeyGenerator().jwkFromSecretKey(
      secretKey: currentAccount.secretKey,
      accountType: currentAccount.blockchainType.accountType,
    );

    final String issuer = DIDKitProvider().keyToDID(didMethod, jwkKey);

    return issuer;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvanceSettingsCubit, AdvanceSettingsState>(
      builder: (context, advanceSettingsState) {
        final profileModel = context.read<ProfileCubit>().state.model;

        final customOidc4vcProfile = profileModel
            .profileSetting.selfSovereignIdentityOptions.customOidc4vcProfile;

        return RefreshIndicator(
          onRefresh: widget.onRefresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.space2XSmall),
            child: FutureBuilder<String>(
              future: getDid(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    final issuerDid = snapshot.data;
                    return ListView(
                      scrollDirection: Axis.vertical,
                      children: getCredentialCategorySorted.where(
                        (category) {
                          return advanceSettingsState
                                  .categoryIsEnabledMap[category] ??
                              true;
                        },
                      ).map((category) {
                        final categorizedCredentials = widget.credentials.where(
                          (element) {
                            /// id credential category does not match, do
                            /// not show
                            if (element.credentialPreview.credentialSubjectModel
                                    .credentialCategory !=
                                category) {
                              return false;
                            }

                            /// wallet credential to be shown always
                            if (element.credentialPreview.credentialSubjectModel
                                    .credentialSubjectType ==
                                CredentialSubjectType.walletCredential) {
                              if (!profileModel.isDeveloperMode) {
                                return false;
                              }
                            }

                            /// crypto credential account to be shown always
                            if (element.credentialPreview.credentialSubjectModel
                                .credentialSubjectType.isBlockchainAccount) {
                              /// only show crypto card with matches current
                              /// account wallet address

                              final currentAccount = context
                                  .read<WalletCubit>()
                                  .state
                                  .currentAccount;

                              if (currentAccount != null) {
                                final currentWalletAddress =
                                    currentAccount.walletAddress;

                                final currentBlockchainType =
                                    currentAccount.blockchainType;

                                final (walletAddress, blockchainType) =
                                    getWalletAddress(
                                  element
                                      .credentialPreview.credentialSubjectModel,
                                );

                                final matchesWalletAddress =
                                    currentWalletAddress !=
                                        walletAddress.toString();

                                final matchesBlockchainType =
                                    currentBlockchainType != blockchainType;

                                if (matchesWalletAddress ||
                                    matchesBlockchainType) {
                                  return false;
                                }
                              }
                            }

                            /// if crypto did matches with vc.
                            if (issuerDid ==
                                element.credentialPreview.credentialSubjectModel
                                    .id) {
                              return true;
                            }

                            if (element.credentialPreview.credentialSubjectModel
                                    .credentialSubjectType !=
                                CredentialSubjectType.walletCredential) {
                              /// do not load the credential if vc format is
                              /// different

                              final formatsSupported = customOidc4vcProfile
                                  .formatsSupported!
                                  .map((e) => e.vcValue)
                                  .toList();

                              if (!formatsSupported
                                      .contains(element.getFormat) &&
                                  element.getFormat != 'auto' &&
                                  !formatsSupported.contains('auto')) {
                                return false;
                              }
                            }

                            return true;
                          },
                        ).toList();
                        if (categorizedCredentials.isEmpty) {
                          if (category.showInHomeIfListEmpty) {
                            return HomeCredentialCategoryItem(
                              credentials: const [],
                              credentialCategory: category,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        } else {
                          return HomeCredentialCategoryItem(
                            credentials: categorizedCredentials,
                            credentialCategory: category,
                          );
                        }
                      }).toList(),
                    );
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  case ConnectionState.active:
                    return const SizedBox();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
