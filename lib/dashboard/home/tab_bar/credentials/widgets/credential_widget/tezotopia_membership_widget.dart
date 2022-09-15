import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TezotopiaMemberShipDisplayInList extends StatelessWidget {
  const TezotopiaMemberShipDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TezotopiaMemberShipRecto(credentialModel: credentialModel);
  }
}

class TezotopiaMemberShipDisplayInSelectionList extends StatelessWidget {
  const TezotopiaMemberShipDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TezotopiaMemberShipRecto(credentialModel: credentialModel);
  }
}

class TezotopiaMemberShipDisplayDetail extends StatelessWidget {
  const TezotopiaMemberShipDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TezotopiaMemberShipRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class TezotopiaMemberShipRecto extends Recto {
  const TezotopiaMemberShipRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const CredentialImage(image: ImageStrings.tezotopiaMemberShip);
  }
}
