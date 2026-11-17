import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_ui/wallet_ui.dart';

/// A credential of the discover catalogue: opens its detail page.
class DiscoverCredentialTile extends StatelessWidget {
  const DiscoverCredentialTile({super.key, required this.dummyCredential});

  final DiscoverDummyCredential dummyCredential;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WalletCredentialContainer(
      title: dummyCredential.discoverName,
      media: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: DummyCredentialImage(
          displayExternalIssuer: dummyCredential.display,
          credentialSubjectType: dummyCredential.credentialSubjectType,
          image: dummyCredential.image,
        ),
      ),
      onTap: () async {
        if (context.read<HomeCubit>().state.homeStatus ==
            HomeStatus.hasNoWallet) {
          await showDialog<void>(
            context: context,
            builder: (_) => const WalletDialog(),
          );
          return;
        }
        await Navigator.push<void>(
          context,
          DiscoverDetailsPage.route(
            dummyCredential: dummyCredential,
            buttonText: l10n.getThisCard,
            onCallBack: () async {
              LoadingView().show(context: context);
              await discoverCredential(
                dummyCredential: dummyCredential,
                context: context,
              );
              Navigator.pop(context);
              LoadingView().hide();
            },
          ),
        );
      },
    );
  }
}
