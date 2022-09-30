import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/app/shared/constants/discover_list.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCredentialItem extends StatelessWidget {
  const HomeCredentialItem({Key? key, required this.homeCredential})
      : super(key: key);

  final HomeCredential homeCredential;

  @override
  Widget build(BuildContext context) {
    return homeCredential.isDummy
        ? DummyCredentialItem(
            homeCredential: homeCredential,
          )
        : RealCredentialItem(
            credentialModel: homeCredential.credentialModel!,
          );
  }
}

class RealCredentialItem extends StatelessWidget {
  const RealCredentialItem({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BackgroundCard(
      color: Theme.of(context).colorScheme.credentialBackground,
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push<void>(
            CredentialsDetailsPage.route(credentialModel),
          );
        },
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: CredentialsListPageItem(
                credentialModel: credentialModel,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Image.asset(
                    IconStrings.checkCircleGreen,
                    height: 15,
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: MyText(
                      l10n.inMyWallet,
                      style: Theme.of(context).textTheme.credentialSurfaceText,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DummyCredentialItem extends StatelessWidget {
  const DummyCredentialItem({Key? key, required this.homeCredential})
      : super(key: key);

  final HomeCredential homeCredential;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BackgroundCard(
      color: Theme.of(context).colorScheme.credentialBackground,
      padding: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () async {
          if (context.read<HomeCubit>().state.homeStatus ==
              HomeStatus.hasNoWallet) {
            await showDialog<void>(
              context: context,
              builder: (_) => const WalletDialog(),
            );
            return;
          }
          final List<CredentialSubjectType> credentialSubjectTypeList =
              List.of(DiscoverList.identityCategories);
          credentialSubjectTypeList.remove(CredentialSubjectType.emailPass);
          if (credentialSubjectTypeList.contains(
            homeCredential.credentialSubjectType,
          )) {
            await context.read<HomeCubit>().checkForPassBaseStatusThenLaunchUrl(
                  link: homeCredential.link!,
                );
          } else {
            await LaunchUrl.launch(homeCredential.link!);
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: CredentialContainer(
                child: Image.asset(homeCredential.image!, fit: BoxFit.fill),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.getThisCard,
                      style: Theme.of(context).textTheme.getCardsButton,
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      IconStrings.addCircle,
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
