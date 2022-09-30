import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/models/author/author.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class DisplayIssuer extends StatelessWidget {
  const DisplayIssuer({
    Key? key,
    required this.issuer,
  }) : super(key: key);

  final Author issuer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Text('${localizations.issuer} '),
        MyText(
          issuer.name,
          style: Theme.of(context).textTheme.credentialIssuer,
        ),
        const Spacer(),
        if (issuer.logo.isNotEmpty)
          CachedImageFromNetwork(
            issuer.logo,
            fit: BoxFit.cover,
          )
        else
          const SizedBox.shrink()
      ],
    );
  }
}
