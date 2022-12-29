import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TwitterCardDisplayInList extends StatelessWidget {
  const TwitterCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TwitterCardRecto(credentialModel: credentialModel);
  }
}

class TwitterCardDisplayInSelectionList extends StatelessWidget {
  const TwitterCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TwitterCardRecto(credentialModel: credentialModel);
  }
}

class TwitterCardDisplayDetail extends StatelessWidget {
  const TwitterCardDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TwitterCardRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class TwitterCardRecto extends Recto {
  const TwitterCardRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const CredentialImage(
      image: ImageStrings.twitterCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
