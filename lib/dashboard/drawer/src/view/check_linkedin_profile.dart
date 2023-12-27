import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckForLinkedInProfile extends StatelessWidget {
  const CheckForLinkedInProfile({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/CheckForLinkedInProfile'),
      builder: (_) => const CheckForLinkedInProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CheckForLinkedInProfileView();
  }
}

class CheckForLinkedInProfileView extends StatelessWidget {
  const CheckForLinkedInProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.drawerBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BackLeadingButton(
                  padding: EdgeInsets.zero,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                WalletLogo(
                  profileModel: context.read<ProfileCubit>().state.model,
                  height: 90,
                  width: MediaQuery.of(context).size.shortestSide * 0.5,
                  showPoweredBy: true,
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                DrawerItem(
                  title: l10n.scanAndDisplay,
                  onTap: () async {
                    final result = await Navigator.push<String?>(
                      context,
                      QrScannerPage.route(),
                    );
                    if (result?.startsWith('{"@context"') ?? false) {
                      final Map<String, dynamic> data =
                          jsonDecode(result!) as Map<String, dynamic>;

                      final Credential credentialPreview = Credential.fromJson(
                        data['verifiableCredential'] as Map<String, dynamic>,
                      );

                      final CredentialModel credentialModel = CredentialModel(
                        id: '',
                        credentialPreview: credentialPreview,
                        data: data['verifiableCredential']
                            as Map<String, dynamic>,
                        image: '',
                        shareLink: '',
                        jwt: null,
                        format: 'ldp_vc',
                      );

                      await Navigator.of(context).push<void>(
                        CredentialsDetailsPage.route(
                          credentialModel: credentialModel,
                          readOnly: true,
                        ),
                      );
                    } else {
                      //invalid text
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
