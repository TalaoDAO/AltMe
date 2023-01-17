import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BackgroundCard(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push<void>(
            CredentialsDetailsPage.route(credentialModel),
          );
        },
        child: CredentialsListPageItem(
          credentialModel: credentialModel,
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

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
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
                await discoverCredential(
                  homeCredential: homeCredential,
                  context: context,
                );
                Navigator.pop(context);
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
                        delegate: DummyCredentialItemDelegate(
                          position: Offset.zero,
                        ),
                        children: [
                          LayoutId(
                            id: 'dummyDesc',
                            child: FractionallySizedBox(
                              widthFactor: 0.85,
                              heightFactor: 0.42,
                              child: Text(
                                homeCredential.dummyDescription!.getMessage(
                                  context,
                                  homeCredential.dummyDescription!,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .discoverOverlayDescription,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
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
