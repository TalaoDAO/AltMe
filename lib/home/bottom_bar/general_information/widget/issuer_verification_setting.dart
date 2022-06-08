import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/issuer_verification_registry.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IssuerVerificationSetting extends StatelessWidget {
  const IssuerVerificationSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ProfileCubit, ProfileState>(
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                l10n.issuerVerificationSetting,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                IssuerVerificationRegistrySelector(
                  issuerVerificationRegistry: IssuerVerificationRegistry.Talao,
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
                        .bodyText2
                        ?.copyWith(color: Colors.grey),
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
    );
  }
}

class IssuerVerificationRegistrySelector extends StatefulWidget {
  const IssuerVerificationRegistrySelector({
    Key? key,
    required this.issuerVerificationRegistry,
    required this.groupValue,
  }) : super(key: key);

  final IssuerVerificationRegistry issuerVerificationRegistry;
  final IssuerVerificationRegistry groupValue;

  @override
  State<IssuerVerificationRegistrySelector> createState() =>
      _IssuerVerificationRegistrySelectorState();
}

class _IssuerVerificationRegistrySelectorState
    extends State<IssuerVerificationRegistrySelector> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(
            widget.issuerVerificationRegistry.name,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          trailing: Radio<IssuerVerificationRegistry>(
            value: widget.issuerVerificationRegistry,
            groupValue: widget.groupValue,
            onChanged: (IssuerVerificationRegistry? value) async {
              if (value != null) {
                await context
                    .read<ProfileCubit>()
                    .updateIssuerVerificationUrl(value);
              }
            },
          ),
        );
      },
    );
  }
}
