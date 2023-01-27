import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DidKey extends StatelessWidget {
  const DidKey({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DIDCubit, DIDState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final String did = state.did!;

        return Row(
          children: [
            Text(
              '${l10n.didDisplayId} : ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Expanded(
              child: Text(
                did != ''
                    ? '''${did.substring(0, 10)} ... ${did.substring(did.length - 10)}'''
                    : '',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        );
      },
    );
  }
}
