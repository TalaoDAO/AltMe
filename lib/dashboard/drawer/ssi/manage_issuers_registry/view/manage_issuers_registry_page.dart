import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageIssuersRegistryPage extends StatelessWidget {
  const ManageIssuersRegistryPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (_) => const ManageIssuersRegistryPage(),
        settings: const RouteSettings(name: '/manageIssuersRegistryPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.chooseIssuersRegistry,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: true,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        bloc: context.read<ProfileCubit>(),
        listener: (context, state) {
          if (state.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }
        },
        builder: (context, state) {
          //const fakeGroupValue = 'titi';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  l10n.chooseIssuerRegistryDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall3,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: Sizes.spaceSmall),
                child: Text(
                  l10n.polygon,
                  style: Theme.of(context).textTheme.subtitle3,
                ),
              ),
              GroupedSection(
                children: [
                  IssuerVerificationRegistrySelector(
                    issuerVerificationRegistry:
                        IssuerVerificationRegistry.PolygonMainnet,
                    isChecked: state.model.issuerVerificationUrls
                        .contains(Urls.checkIssuerPolygonUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.spaceSmall,
                    ),
                    child: Divider(
                      color: Theme.of(context).colorScheme.borderColor,
                    ),
                  ),
                  IssuerVerificationRegistrySelector(
                    issuerVerificationRegistry:
                        IssuerVerificationRegistry.PolygonTestnet,
                    isChecked: state.model.issuerVerificationUrls
                        .contains(Urls.checkIssuerPolygonTestnetUrl),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: Sizes.spaceSmall),
                child: Text(
                  l10n.ebsi,
                  style: Theme.of(context).textTheme.subtitle3,
                ),
              ),
              GroupedSection(
                children: [
                  IssuerVerificationRegistrySelector(
                    issuerVerificationRegistry: IssuerVerificationRegistry.EBSI,
                    isChecked: state.model.issuerVerificationUrls
                        .contains(Urls.checkIssuerEbsiUrl),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
