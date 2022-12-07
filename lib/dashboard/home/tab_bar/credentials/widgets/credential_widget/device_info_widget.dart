import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DeviceInfoDisplayInList extends StatelessWidget {
  const DeviceInfoDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DeviceInfoRecto(
      credentialModel: credentialModel,
    );
  }
}

class DeviceInfoDisplayInSelectionList extends StatelessWidget {
  const DeviceInfoDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DeviceInfoRecto(
      credentialModel: credentialModel,
    );
  }
}

class DeviceInfoDisplayDetail extends StatelessWidget {
  const DeviceInfoDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DeviceInfoRecto(
      credentialModel: credentialModel,
    );
  }
}

class DeviceInfoRecto extends Recto {
  const DeviceInfoRecto({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final deviceInfo = credentialModel.credentialPreview.credentialSubjectModel
        as DeviceInfoModel;
    return CredentialImage(
      image: deviceInfo.systemName == 'iOS'
          ? ImageStrings.iOSProof
          : ImageStrings.androidProof,
      child: const AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
