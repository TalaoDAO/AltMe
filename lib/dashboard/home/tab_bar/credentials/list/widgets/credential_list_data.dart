import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialListData extends StatelessWidget {
  const CredentialListData({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  final CredentialListState state;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AdvanceSettingsCubit, AdvanceSettingsState>(
      builder: (context, advanceSettingsState) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.space2XSmall),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                if (advanceSettingsState.isGamingEnabled) ...[
                  /// Gaming Credentials
                  HomeCredentialWidget(
                    title: l10n.gamingCards,
                    credentials: state.gamingCredentials,
                    showAddOption: true,
                    categorySubtitle: l10n.gamingCredentialHomeSubtitle,
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                ],
                if (advanceSettingsState.isCommunityEnabled &&
                    state.communityCredentials.isNotEmpty) ...[
                  /// Community Credentials
                  HomeCredentialWidget(
                    title: l10n.communityCards,
                    credentials: state.communityCredentials,
                    showAddOption: true,
                    categorySubtitle: l10n.communityCredentialHomeSubtitle,
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                ],
                if (advanceSettingsState.isIdentityEnabled) ...[
                  /// Identity Credentials
                  HomeCredentialWidget(
                    title: l10n.identityCards,
                    credentials: state.identityCredentials,
                    showAddOption: true,
                    categorySubtitle: l10n.identityCredentialHomeSubtitle,
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                ],
                if (advanceSettingsState.isEducationEnabled &&
                    state.educationCredentials.isNotEmpty) ...[
                  /// Education Credentials
                  HomeCredentialWidget(
                    title: l10n.educationCredentials,
                    credentials: state.educationCredentials,
                    categorySubtitle: l10n.educationCredentialHomeSubtitle,
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                ],
                if (advanceSettingsState.isPassEnabled &&
                    state.passCredentials.isNotEmpty) ...[
                  /// Pass Credentials
                  HomeCredentialWidget(
                    title: l10n.pass,
                    credentials: state.passCredentials,
                    categorySubtitle: l10n.passCredentialHomeSubtitle,
                    showAddOption: true,
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                ],
                if (state.myProfessionalCredentials.isNotEmpty) ...[
                  /// My Professional Credentials
                  HomeCredentialWidget(
                    title: l10n.myProfessionalrCards,
                    credentials: state.myProfessionalCredentials,
                    showAddOption: true,
                    categorySubtitle: l10n.myProfessionalrCardsSubtitle,
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                ],
                if (advanceSettingsState.isOtherEnabled &&
                    state.othersCredentials.isNotEmpty) ...[
                  /// Other Credentials
                  HomeCredentialWidget(
                    title: l10n.otherCards,
                    credentials: state.othersCredentials,
                    showAddOption: true,
                    categorySubtitle: l10n.otherCredentialHomeSubtitle,
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                ],
                if (advanceSettingsState.isBlockchainAccountsEnabled &&
                    state.blockchainAccountsCredentials.isNotEmpty) ...[
                  /// BlockchainAccounts Credentials
                  HomeCredentialWidget(
                    title: l10n.blockchainAccounts,
                    credentials: state.blockchainAccountsCredentials,
                    categorySubtitle:
                        l10n.blockchainAccountsCredentialHomeSubtitle,
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
