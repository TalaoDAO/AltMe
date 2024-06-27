import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletLogo extends StatelessWidget {
  const WalletLogo({
    super.key,
    this.height,
    this.width,
    this.showPoweredBy = false,
  });

  final double? height;
  final double? width;
  final bool showPoweredBy;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final FlavorCubit flavorCubit = context.read<FlavorCubit>();
        String image = '';

        final profileModel = state.model;

        switch (profileModel.profileType) {
          case ProfileType.custom:
          case ProfileType.dutch:
          case ProfileType.defaultOne:
            image = flavorCubit.state == FlavorMode.development
                ? ImageStrings.appLogoDev
                : flavorCubit.state == FlavorMode.staging
                    ? ImageStrings.appLogoStage
                    : ImageStrings.appLogo;
          case ProfileType.ebsiV3:
            image = ImageStrings.ebsiLogo;
          case ProfileType.enterprise:
            image = profileModel.profileSetting.generalOptions.companyLogo;
          case ProfileType.owfBaselineProfile:
            image = ImageStrings.owfBaselineProfileLogo;
        }
        return Column(
          children: [
            Center(
              child: SizedBox(
                width: width,
                height: height,
                child: profileModel.profileType == ProfileType.enterprise
                    ? CachedImageFromNetwork(
                        image,
                        fit: BoxFit.contain,
                        width: width,
                        bgColor: Colors.transparent,
                        height: height,
                        errorMessage: '',
                        showLoading: false,
                      )
                    : Image.asset(
                        image,
                        fit: BoxFit.contain,
                        width: width,
                        height: height,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
