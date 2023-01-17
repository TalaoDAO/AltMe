import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:flutter/material.dart';

class SoftwareLicenseDetailsPage extends StatelessWidget {
  const SoftwareLicenseDetailsPage({
    Key? key,
    required this.licenseModel,
  }) : super(key: key);

  final LicenseModel licenseModel;

  static Route route({required LicenseModel licenseModel}) {
    return MaterialPageRoute<void>(
      builder: (_) => SoftwareLicenseDetailsPage(licenseModel: licenseModel),
      settings: const RouteSettings(name: '/SoftwareLicenseDetailsPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SoftwareLicenseDetailsView(licenseModel: licenseModel);
  }
}

class SoftwareLicenseDetailsView extends StatelessWidget {
  const SoftwareLicenseDetailsView({
    Key? key,
    required this.licenseModel,
  }) : super(key: key);

  final LicenseModel licenseModel;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scrollView: false,
      title: licenseModel.title,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.spaceXSmall),
            child: Text(licenseModel.description),
          ),
        ),
      ),
    );
  }
}
