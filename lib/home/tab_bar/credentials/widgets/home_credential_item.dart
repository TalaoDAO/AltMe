import 'package:altme/app/app.dart';
import 'package:altme/app/shared/constants/icon_strings.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class HomeCredentialItem extends StatelessWidget {
  const HomeCredentialItem({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return RealCredentialItem(
      credentialModel: credentialModel,
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
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: CredentialsListPageItem(
              credentialModel: credentialModel,
              onTap: () {},
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Image.asset(
                        IconStrings.tickCircle,
                        height: 15,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: MyText(
                          l10n.inMyWallet,
                          style:
                              Theme.of(context).textTheme.credentialSurfaceText,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push<void>(
                        CredentialsDetailsPage.route(credentialModel),
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          IconStrings.frame,
                          height: 15,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: MyText(
                            l10n.details,
                            style: Theme.of(context)
                                .textTheme
                                .credentialSurfaceText
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
