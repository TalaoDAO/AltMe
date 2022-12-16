import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IssuerVerificationRegistrySelector extends StatelessWidget {
  const IssuerVerificationRegistrySelector({
    Key? key,
    required this.issuerVerificationRegistry,
    required this.groupValue,
    this.isEnable = true,
  }) : super(key: key);

  final IssuerVerificationRegistry issuerVerificationRegistry;
  final IssuerVerificationRegistry groupValue;
  final bool isEnable;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Opacity(
          opacity: isEnable ? 1 : 0.5,
          child: ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            onTap: !isEnable
                ? null
                : () {
                    context.read<ProfileCubit>().updateIssuerVerificationUrl(
                          issuerVerificationRegistry,
                        );
                  },
            title: Text(
              issuerVerificationRegistry.name,
              style: Theme.of(context).textTheme.radioOption,
            ),
            trailing: issuerVerificationRegistry == groupValue
                ? Icon(
                    Icons.check_circle,
                    size: Sizes.icon2x,
                    color: Theme.of(context).colorScheme.onSurface,
                  )
                : Icon(
                    Icons.circle_outlined,
                    size: Sizes.icon2x,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
          ),
        );
      },
    );
  }
}
