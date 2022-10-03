import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/models/home_credential/home_credential.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/home_credential_item.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class GamingCredentials extends StatelessWidget {
  const GamingCredentials({
    Key? key,
    required this.credentials,
    this.isDiscover = false,
  }) : super(key: key);

  final List<HomeCredential> credentials;
  final bool isDiscover;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '''${l10n.gamingCards} (${credentials.where((element) => !element.isDummy).toList().length})''',
          style: Theme.of(context).textTheme.credentialCategoryTitle,
        ),
        const SizedBox(
          height: 8,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: Sizes.homeCredentialRatio,
          ),
          itemCount: credentials.length + (isDiscover ? 0 : 1),
          itemBuilder: (_, index) {
            if (!isDiscover && index == credentials.length) {
              return const AddCredentialButton();
            } else {
              return HomeCredentialItem(
                homeCredential: credentials[index],
              );
            }
          },
        ),
      ],
    );
  }
}
