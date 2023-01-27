import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/author/author.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DisplayIssuer extends StatelessWidget {
  const DisplayIssuer({
    super.key,
    required this.issuer,
  });

  final Author issuer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MyText(
            issuer.name,
            style: Theme.of(context).textTheme.credentialIssuer,
          ),
        ),
      ],
    );
  }
}
