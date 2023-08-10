import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Oidc4vcCredentialPickPage extends StatelessWidget {
  const Oidc4vcCredentialPickPage({
    super.key,
    required this.credentials,
  });

  final List<dynamic> credentials;

  static Route<dynamic> route({
    required List<dynamic> credentials,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => Oidc4vcCredentialPickPage(
          credentials: credentials,
        ),
        settings: const RouteSettings(name: '/Oidc4vcCredentialPickPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Oidc4vcCredentialPickCubit(),
      child: Oidc4vcCredentialPickView(credentials: credentials),
    );
  }
}

class Oidc4vcCredentialPickView extends StatelessWidget {
  const Oidc4vcCredentialPickView({
    super.key,
    required this.credentials,
  });

  final List<dynamic> credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<QRCodeScanCubit, QRCodeScanState>(
      listener: (context, state) {
        if (state.status == QrScanStatus.goBack) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<Oidc4vcCredentialPickCubit, List<int>>(
        builder: (context, state) {
          return BasePage(
            title: l10n.credentialPickTitle,
            titleTrailing: const WhiteCloseButton(),
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            navigation: SafeArea(
                child: Container(
              padding: const EdgeInsets.all(16),
              child: MyGradientButton(
                onPressed: state.isEmpty
                    ? null
                    : () {
                        if (state.isEmpty) return;

                        final creds = <dynamic>[];

                        for (int i = 0; i < state.length; i++) {
                          creds.add(credentials[i]);
                        }

                        context
                            .read<QRCodeScanCubit>()
                            .addCredentialsInLoop(creds);
                      },
                text: l10n.proceed,
              ),
            )),
            body: Column(
              children: <Widget>[
                ...List.generate(
                  credentials.length,
                  (index) {
                    final CredentialSubjectType credentialSubjectType =
                        getCredTypeFromName(credentials[index].toString()) ??
                            CredentialSubjectType.defaultCredential;

                    final DiscoverDummyCredential discoverDummyCredential =
                        DiscoverDummyCredential.fromSubjectType(
                      credentialSubjectType,
                    );

                    return TransparentInkWell(
                      onTap: () => context
                          .read<Oidc4vcCredentialPickCubit>()
                          .updateList(index),
                      child: Column(
                        children: [
                          if (discoverDummyCredential.image != null) ...[
                            DummyCredentialImage(
                              discoverDummyCredential: discoverDummyCredential,
                            ),
                          ] else ...[
                            AspectRatio(
                              aspectRatio: Sizes.credentialAspectRatio,
                              child: DefaultCredentialListWidget(
                                credentialModel: CredentialModel(
                                  id: '',
                                  credentialPreview: Credential(
                                    'dummy1',
                                    ['dummy2'],
                                    [credentials[index].toString()],
                                    'dummy4',
                                    'dummy5',
                                    'dummy6',
                                    [Proof.dummy()],
                                    DefaultCredentialSubjectModel(
                                      'dummy7',
                                      'dummy8',
                                      const Author(''),
                                    ),
                                    [Translation('en', '')],
                                    [Translation('en', '')],
                                    CredentialStatusField
                                        .emptyCredentialStatusField(),
                                    [Evidence.emptyEvidence()],
                                  ),
                                  data: const {},
                                  display: Display.emptyDisplay(),
                                  image: '',
                                  shareLink: '',
                                ),
                                showBgDecoration: false,
                              ),
                            )
                          ],
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                state.contains(index)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 25,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
