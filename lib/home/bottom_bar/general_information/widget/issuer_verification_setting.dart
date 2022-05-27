import 'package:altme/app/app.dart';
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
        final issuerVerificationSetting = state.model.issuerVerificationSetting;
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(
                l10n.issuerVerificationSetting,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const Spacer(),
              Switch(
                onChanged: (value) {
                  final profileModel = state.model.copyWith(
                    issuerVerificationSetting: value,
                  );
                  context.read<ProfileCubit>().update(profileModel);
                },
                value: issuerVerificationSetting,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
