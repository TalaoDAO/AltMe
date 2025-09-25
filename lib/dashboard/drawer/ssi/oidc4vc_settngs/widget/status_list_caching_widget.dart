import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusListCachingWidget extends StatelessWidget {
  const StatusListCachingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: 'StatusList caching',
          subtitle: 'Switch off to reload StatusList when needed. Default: On.',
          body: Switch(
            onChanged: (value) async {
              await context.read<ProfileCubit>().updateProfileSetting(
                    statusListCaching: value,
                  );
            },
            value: state.model.profileSetting.selfSovereignIdentityOptions
                .customOidc4vcProfile.statusListCache,
            activeThumbColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
