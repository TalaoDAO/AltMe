import 'package:altme/app/app.dart';
import 'package:altme/app/shared/widget/divider_for_radio_list.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class ClientTypeWidget extends StatelessWidget {
  const ClientTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: 'Wallet Client_id Scheme',
          subtitle: 'Confidential Client',
          body: ListView.builder(
            itemCount: ClientType.values.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final clientType = ClientType.values[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      context.read<ProfileCubit>().updateProfileSetting(
                            clientType: clientType,
                          );
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.5,
                      ),
                    ),
                    title: Text(
                      clientType.getTitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(
                      state.model.profileSetting.selfSovereignIdentityOptions
                                  .customOidc4vcProfile.clientType ==
                              clientType
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: Sizes.icon2x,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const DividerForRadioList(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
