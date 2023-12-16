import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialActiveStatus extends StatelessWidget {
  const CredentialActiveStatus({
    super.key,
    required this.credentialStatus,
  });

  final CredentialStatus? credentialStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: '${l10n.credentialStatus}: ',
                    style: Theme.of(context)
                        .textTheme
                        .credentialFieldTitle
                        .copyWith(
                          color: Theme.of(context).colorScheme.titleColor,
                        ),
                  ),
                  TextSpan(
                    text: credentialStatus?.message(context) ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .credentialFieldDescription
                        .copyWith(
                          color: Theme.of(context).colorScheme.valueColor,
                        ),
                  ),
                ],
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
            credentialStatus?.info(context) != null &&
            credentialStatus!.info(context).isNotEmpty)
          Text(
            credentialStatus?.info(context) ?? '',
            style:
                Theme.of(context).textTheme.credentialFieldDescription.copyWith(
                      color: Theme.of(context).colorScheme.valueColor,
                    ),
          ),
      ],
    );
  }
}
