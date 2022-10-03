import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IssuerVerificationRegistrySelector extends StatelessWidget {
  const IssuerVerificationRegistrySelector({
    Key? key,
    required this.issuerVerificationRegistry,
    required this.groupValue,
  }) : super(key: key);

  final IssuerVerificationRegistry issuerVerificationRegistry;
  final IssuerVerificationRegistry groupValue;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(
            issuerVerificationRegistry.name,
            style: Theme.of(context).textTheme.radioOption,
          ),
          trailing: Radio<IssuerVerificationRegistry>(
            value: issuerVerificationRegistry,
            groupValue: groupValue,
            activeColor: Theme.of(context).colorScheme.onPrimary,
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
