import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/delete_credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_ui/wallet_ui.dart';

/// A credential of the wallet as a wallet_ui container: its name and issuer
/// over its card image. A long press offers to delete it, unless it can't be.
class CredentialContainerCard extends StatelessWidget {
  const CredentialContainerCard({
    super.key,
    required this.credentialModel,
    required this.onTap,
    this.badgeCount = 0,
  });

  final CredentialModel credentialModel;
  final VoidCallback onTap;

  /// Unread chat messages of the credential's support room.
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final profileSetting = context
        .read<ProfileCubit>()
        .state
        .model
        .profileSetting;
    // A batch is shown as one card, with the number of copies left.
    final batchId = credentialModel.batchId;
    final copyCount = batchId == null
        ? 1
        : context.select<CredentialsCubit, int>(
            (cubit) => cubit.state.credentials
                .where((credential) => credential.batchId == batchId)
                .length,
          );
    final issuer =
        credentialModel.credentialPreview.credentialSubjectModel.issuedBy?.name;
    return WalletCredentialContainer(
      title: credentialModel.getName,
      subtitle: issuer == null || issuer.isEmpty ? null : issuer,
      onTap: onTap,
      onLongPress: credentialModel.disAllowDelete
          ? null
          : () => deleteCredential(context, credentialModel.id),
      badge: copyCount > 1
          ? BatchCountBadge(count: copyCount, small: true)
          : badgeCount > 0
          ? Badge.count(count: badgeCount)
          : null,
      media: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CredentialDisplay(
          credentialModel: credentialModel,
          credDisplayType: CredDisplayType.List,
          profileSetting: profileSetting,
          isDiscover: false,
          showPortrait: true,
        ),
      ),
    );
  }
}
