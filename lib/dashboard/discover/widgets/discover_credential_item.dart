import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverCredentialItem extends StatelessWidget {
  const DiscoverCredentialItem({
    super.key,
    required this.dummyCredential,
  });

  final DiscoverDummyCredential dummyCredential;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      onTap: () async {
        if (context.read<HomeCubit>().state.homeStatus ==
            HomeStatus.hasNoWallet) {
          await showDialog<void>(
            context: context,
            builder: (_) => const WalletDialog(),
          );
          return;
        }
// If dummyCredential is an external issuer we don't display the detail screen
// we go directly to the issuer endpoint
        await Navigator.push<void>(
          context,
          DiscoverDetailsPage.route(
            dummyCredential: dummyCredential,
            buttonText: l10n.getThisCard,
            onCallBack: () async {
              await discoverCredential(
                dummyCredential: dummyCredential,
                context: context,
              );
              Navigator.pop(context);
            },
          ),
        );
      },
      child: DummyCredentialImage(
        displayExternalIssuer: dummyCredential.display,
        credentialSubjectType: dummyCredential.credentialSubjectType,
        image: dummyCredential.image,
      ),
    );
  }
}
