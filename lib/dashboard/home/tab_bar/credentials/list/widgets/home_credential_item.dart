import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class HomeCredentialItem extends StatelessWidget {
  const HomeCredentialItem({
    Key? key,
    required this.homeCredential,
    required this.fromDiscover,
  }) : super(key: key);

  final HomeCredential homeCredential;
  final bool fromDiscover;

  @override
  Widget build(BuildContext context) {
    return homeCredential.isDummy
        ? DummyCredentialItem(
            homeCredential: homeCredential,
            fromDiscover: fromDiscover,
          )
        : RealCredentialItem(credentialModel: homeCredential.credentialModel!);
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
  const DummyCredentialItem({
    Key? key,
    required this.homeCredential,
    required this.fromDiscover,
  }) : super(key: key);

  final HomeCredential homeCredential;
  final bool fromDiscover;

  Future<void> goAhead(BuildContext context) async {
    final l10n = context.l10n;

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
      /// check if  credential it is
      /// [CredentialSubjectType.tezotopiaMembership]
      if (homeCredential.credentialSubjectType ==
          CredentialSubjectType.tezotopiaMembership) {
        final CredentialsRepository repository =
            CredentialsRepository(getSecureStorage);

        final List<CredentialModel> allCredentials = await repository.findAll();

        bool isPresentable = false;

        for (final type in membershipRequiredList) {
          for (final credential in allCredentials) {
            if (type ==
                credential.credentialPreview.credentialSubjectModel
                    .credentialSubjectType) {
              isPresentable = true;
              break;
            } else {
              isPresentable = false;
            }
          }
          if (!isPresentable) {
            await showDialog<bool>(
              context: context,
              builder: (context) => InfoDialog(
                title:
                    '''${l10n.membershipRequiredListAlerMessage}\n\n 1. Nationality Proof\n 2. Age Range Proof''',
                button: l10n.ok,
              ),
            );
            return;
          }
        }
      }
      await LaunchUrl.launch(homeCredential.link!);
    }
  }

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

          await Navigator.push<void>(
            context,
            DiscoverDetailsPage.route(
              homeCredential: homeCredential,
              onCallBack: () async {
                Navigator.pop(context);
                await goAhead(context);
              },
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: CredentialImage(
                image: homeCredential.image!,
                child: homeCredential.dummyDescription == null
                    ? null
                    : CustomMultiChildLayout(
                        delegate:
                            DummyCredentialItemDelegate(position: Offset.zero),
                        children: [
                          LayoutId(
                            id: 'dummyDesc',
                            child: FractionallySizedBox(
                              widthFactor: 0.85,
                              heightFactor: 0.42,
                              child: MyText(
                                homeCredential.dummyDescription!.getMessage(
                                  context,
                                  homeCredential.dummyDescription!,
                                ),
                                maxLines: 3,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      l10n.getIt,
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

class DummyCredentialItemDelegate extends MultiChildLayoutDelegate {
  DummyCredentialItemDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('dummyDesc')) {
      layoutChild('dummyDesc', BoxConstraints.loose(size));
      positionChild(
        'dummyDesc',
        Offset(size.width * 0.06, size.height * 0.35),
      );
    }
  }

  @override
  bool shouldRelayout(DummyCredentialItemDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
