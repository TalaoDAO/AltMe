import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The card of [credentialModel] as every screen that shows what a credential
/// holds displays it: the issuer's picture of the card when there is one,
/// else the credential's own display, with its portrait.
class CredentialCardImage extends StatelessWidget {
  const CredentialCardImage({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final picture = SelectiveDisclosure(credentialModel).getPicture;
    if (picture != null) return PictureDisplay(credentialImage: picture);
    return CredentialDisplay(
      credentialModel: credentialModel,
      credDisplayType: CredDisplayType.List,
      profileSetting: context.read<ProfileCubit>().state.model.profileSetting,
      isDiscover: false,
      showPortrait: true,
    );
  }
}

/// A credential being shared or read: its card, then its fields as
/// `CredentialField`s with `showVertically`, in the colors of the surface.
class CredentialShareCard extends StatelessWidget {
  const CredentialShareCard({
    super.key,
    required this.credentialModel,
    required this.children,
  });

  final CredentialModel credentialModel;

  /// The fields shown under the card.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CredentialCardImage(credentialModel: credentialModel),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}
