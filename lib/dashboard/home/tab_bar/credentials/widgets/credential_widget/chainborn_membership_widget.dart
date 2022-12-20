import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class ChainbornMemberShipDisplayInList extends StatelessWidget {
  const ChainbornMemberShipDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return ChainbornMemberShipRecto(credentialModel: credentialModel);
  }
}

class ChainbornMemberShipDisplayInSelectionList extends StatelessWidget {
  const ChainbornMemberShipDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return ChainbornMemberShipRecto(credentialModel: credentialModel);
  }
}

class ChainbornMemberShipDisplayDetail extends StatelessWidget {
  const ChainbornMemberShipDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChainbornMemberShipRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class ChainbornMemberShipRecto extends Recto {
  const ChainbornMemberShipRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const CredentialImage(
      image: ImageStrings.chainbornMemberShip,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
