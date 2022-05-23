import 'package:altme/app/app.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/home/drawer/global_information/widget/did_display.dart';
import 'package:altme/home/drawer/global_information/widget/issuer_verification_setting.dart';
import 'package:altme/home/drawer/profile/cubit/profile_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalInformationPage extends StatelessWidget {
  const GlobalInformationPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const GlobalInformationPage(),
        settings: const RouteSettings(name: '/globalInformationPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.globalInformationLabel,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IssuerVerificationSetting(),
          DIDDisplay(
            isEnterpriseUser:
                context.read<ProfileCubit>().state.model.isEnterprise,
          ),
          const Spacer(),
          Center(
            child: Text(
              'DIDKit v${context.read<DIDCubit>().didKitProvider.getVersion()}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          const SizedBox(height: 16),
          const AppVersion(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
