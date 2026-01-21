import 'package:altme/app/app.dart';
import 'package:altme/app/shared/widget/divider_for_radio_list.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class ClientAuthenticationWidget extends StatelessWidget {
  const ClientAuthenticationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: 'Client Authentication Methods',
          subtitle:
              'Select to other authentication'
              ' methods if needed. Default: Client id as DID or JWK.',
          body: ListView.builder(
            itemCount: ClientAuthentication.values.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final clientAuthenticationType =
                  ClientAuthentication.values[index];

              if (clientAuthenticationType ==
                  ClientAuthentication.clientSecretJwt) {
                return Container();
              }

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      context.read<ProfileCubit>().updateProfileSetting(
                        clientAuthentication: clientAuthenticationType,
                      );
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.5,
                      ),
                    ),
                    title: Text(
                      clientAuthenticationType.value,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(
                      state
                                  .model
                                  .profileSetting
                                  .selfSovereignIdentityOptions
                                  .customOidc4vcProfile
                                  .clientAuthentication ==
                              clientAuthenticationType
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
