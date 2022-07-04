import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/bottom_bar/general_information/widget/tezos_network_setting.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralInformationPage extends StatelessWidget {
  const GeneralInformationPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const GeneralInformationPage(),
        settings: const RouteSettings(name: '/globalInformationPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.generalInformationLabel,
      titleLeading: const BackLeadingButton(),
      scrollView: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IssuerVerificationSetting(),
          const TezosNetworksetting(),
          DIDDisplay(
            isEnterpriseUser:
                context.read<ProfileCubit>().state.model.isEnterprise,
          ),
          const SizedBox(height: 30),
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
