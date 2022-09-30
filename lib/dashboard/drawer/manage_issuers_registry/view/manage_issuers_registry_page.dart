import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
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
      title: l10n.issuerRegistry,
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
          var groupValue = IssuerVerificationRegistry.Talao;
          switch (state.model.issuerVerificationUrl) {
            case '':
              groupValue = IssuerVerificationRegistry.None;
              break;
            case Urls.checkIssuerEbsiUrl:
              groupValue = IssuerVerificationRegistry.EBSI;
              break;
          }
          const fakeGroupValue = 'titi';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  l10n.issuerVerificationSetting,
                  style: Theme.of(context).textTheme.radioTitle,
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
                  IssuerVerificationRegistrySelector(
                    issuerVerificationRegistry: IssuerVerificationRegistry.EBSI,
                    groupValue: groupValue,
                  ),
                  ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      'Compellio',
                      style: Theme.of(context)
                          .textTheme
                          .radioOption
                          .copyWith(color: Colors.grey),
                    ),
                    trailing: const Radio<String>(
                      value: 'useless',
                      groupValue: fakeGroupValue,
                      onChanged: null,
                    ),
                  ),
                  IssuerVerificationRegistrySelector(
                    issuerVerificationRegistry: IssuerVerificationRegistry.None,
                    groupValue: groupValue,
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
