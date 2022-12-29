import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class MissingCredentialsPage extends StatelessWidget {
  const MissingCredentialsPage({
    Key? key,
    required this.credentialManifest,
  }) : super(key: key);

  final CredentialManifest credentialManifest;

  static Route route({required CredentialManifest credentialManifest}) =>
      MaterialPageRoute<void>(
        builder: (_) =>
            MissingCredentialsPage(credentialManifest: credentialManifest),
        settings: const RouteSettings(name: '/MissingCredentialsPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MissingCredentialsCubit(
        secureStorageProvider: secure_storage.getSecureStorage,
        repository: CredentialsRepository(secure_storage.getSecureStorage),
        credentialManifest: credentialManifest,
      ),
      child: MissingCredentialsView(credentialManifest: credentialManifest),
    );
  }
}

class MissingCredentialsView extends StatelessWidget {
  const MissingCredentialsView({
    Key? key,
    required this.credentialManifest,
  }) : super(key: key);

  final CredentialManifest credentialManifest;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<MissingCredentialsCubit, MissingCredentialsState>(
      builder: (context, state) {
        return BasePage(
          title: l10n.getCards,
          titleAlignment: Alignment.topCenter,
          scrollView: false,
          titleLeading: const BackLeadingButton(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          body: Column(
            children: [
              Text(
                '''${l10n.youAreMissing} ${state.dummyCredentials.length} ${l10n.credentialsRequestedBy} ${credentialManifest.issuedBy!.name}.''',
                style: Theme.of(context).textTheme.discoverFieldDescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: state.dummyCredentials.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final homeCredential = state.dummyCredentials[i];
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 15,
                        right: 10,
                        left: 10,
                      ),
                      child: AspectRatio(
                        aspectRatio: Sizes.credentialAspectRatio,
                        child: CredentialImage(
                          image: homeCredential.image!,
                          child: homeCredential.dummyDescription == null
                              ? null
                              : CustomMultiChildLayout(
                                  delegate: DummyCredentialItemDelegate(
                                    position: Offset.zero,
                                  ),
                                  children: [
                                    LayoutId(
                                      id: 'dummyDesc',
                                      child: FractionallySizedBox(
                                        widthFactor: 0.85,
                                        heightFactor: 0.36,
                                        child: MyText(
                                          homeCredential.dummyDescription!
                                              .getMessage(
                                            context,
                                            homeCredential.dummyDescription!,
                                          ),
                                          maxLines: 3,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              MyGradientButton(
                onPressed: () async {
                  for (final credentials in state.dummyCredentials) {
                    await Navigator.push<void>(
                      context,
                      DiscoverDetailsPage.route(
                        homeCredential: credentials,
                        onCallBack: () async {
                          await discoverCredential(
                            homeCredential: credentials,
                            context: context,
                          );
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                text: l10n.getItNow,
              ),
              const SizedBox(height: 10),
              MyOutlinedButton(
                verticalSpacing: 20,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: l10n.cancel,
              ),
            ],
          ),
        );
      },
    );
  }
}
