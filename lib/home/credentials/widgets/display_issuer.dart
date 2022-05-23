import 'package:altme/app/app.dart';
import 'package:altme/home/credentials/models/author/author.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DisplayIssuer extends StatelessWidget {
  const DisplayIssuer({
    Key? key,
    required this.issuer,
  }) : super(key: key);

  final Author issuer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // Text('${localizations.issuer} '),
          Text(
            issuer.name,
            style: Theme.of(context).textTheme.credentialIssuer,
          ),
          const Spacer(),
          if (issuer.logo.isNotEmpty)
            SizedBox(
              height: 30,
              child: ImageFromNetwork(
                issuer.logo,
                fit: BoxFit.cover,
              ),
            )
          else
            const SizedBox(
              height: 30,
            )
        ],
      ),
    );
  }
}
