import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class SplashImage extends StatelessWidget {
  const SplashImage({
    super.key,
    required this.profileModel,
  });

  final ProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.6;

    final image = profileModel.profileSetting.generalOptions.companyLogo;
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.height * 0.2,
      child: image.isNotEmpty
          ? CachedImageFromNetwork(
              image,
              fit: BoxFit.fitHeight,
              width: width,
              bgColor: Colors.transparent,
              errorMessage: '',
              showLoading: false,
            )
          : Image.asset(
              ImageStrings.splashImage,
              fit: BoxFit.fitHeight,
              width: width,
              height: MediaQuery.of(context).size.longestSide / 5,
            ),
    );
  }
}
