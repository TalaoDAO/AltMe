import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DeviceInfoWidget extends StatelessWidget {
  const DeviceInfoWidget({
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
