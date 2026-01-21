import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:flutter/material.dart';

class SoftwareLicenseDetailsPage extends StatelessWidget {
  const SoftwareLicenseDetailsPage({super.key, required this.licenseModel});

  final LicenseModel licenseModel;

  static Route<dynamic> route({required LicenseModel licenseModel}) {
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
  const SoftwareLicenseDetailsView({super.key, required this.licenseModel});

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
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: licenseModel.description.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceXSmall),
            child: Column(
              children: [
                if (index != 0) ...[
                  const SizedBox(height: Sizes.spaceSmall),
                  const Divider(),
                  const SizedBox(height: Sizes.spaceSmall),
                ],
                Text(licenseModel.description[index]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
