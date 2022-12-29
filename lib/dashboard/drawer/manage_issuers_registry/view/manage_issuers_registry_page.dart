import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageIssuersRegistryPage extends StatelessWidget {
  const ManageIssuersRegistryPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
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
          var groupValue = IssuerVerificationRegistry.None;
          switch (state.model.issuerVerificationUrl) {
            case '':
              groupValue = IssuerVerificationRegistry.None;
              break;
            case Urls.checkIssuerEbsiUrl:
              groupValue = IssuerVerificationRegistry.EBSI;
              break;
            case Urls.checkIssuerTalaoUrl:
              groupValue = IssuerVerificationRegistry.Talao;
              break;
          }
          //const fakeGroupValue = 'titi';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  l10n.chooseIssuerRegistryDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption3,
                ),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  IssuerVerificationRegistrySelector(
                    issuerVerificationRegistry:
                        IssuerVerificationRegistry.Talao,
                    groupValue: groupValue,
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
                    issuerVerificationRegistry: IssuerVerificationRegistry.EBSI,
                    groupValue: groupValue,
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
                        IssuerVerificationRegistry.Compellio,
                    isEnable: false,
                    groupValue: groupValue,
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
                    issuerVerificationRegistry: IssuerVerificationRegistry.None,
                    groupValue: groupValue,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.spaceSmall,
                    ),
                    child: Divider(
                      color: Theme.of(context).colorScheme.borderColor,
                    ),
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
