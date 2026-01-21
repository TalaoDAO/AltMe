import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialActiveStatus extends StatelessWidget {
  const CredentialActiveStatus({super.key, required this.credentialStatus});

  final CredentialStatus? credentialStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              credentialStatus?.message(context) ?? '',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 5),
            if (credentialStatus != null)
              Icon(
                credentialStatus!.icon,
                size: 18,
                color: credentialStatus!.color(context),
              ),
          ],
        ),
        if (context.read<ProfileCubit>().state.model.isDeveloperMode &&
            credentialStatus != null)
          Text('Status label: ${credentialStatus!.message(context)}')
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
