import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DummyCredentialImage extends StatelessWidget {
  const DummyCredentialImage({
    required this.credentialSubjectType,
    required this.image,
    this.credentialName,
    this.aspectRatio = Sizes.credentialAspectRatio,
    super.key,
  });

  final double aspectRatio;
  final CredentialSubjectType credentialSubjectType;
  final String? image;
  final String? credentialName;

  @override
  Widget build(BuildContext context) {
    String? title;

    if (credentialSubjectType == CredentialSubjectType.employeeCredential) {
      title = credentialSubjectType.title;
    }

    var credential = credentialSubjectType.title;

    if (credential == '' && credentialName != null) {
      credential = credentialName!;
    }

    return image == null
        ? DefaultCredentialWidget(
            credentialModel: CredentialModel(
              id: '',
              credentialPreview: Credential(
                'dummy1',
                ['dummy2'],
                [credential],
                'dummy4',
                'dummy5',
                '',
                [Proof.dummy()],
                DefaultCredentialSubjectModel(
                  id: 'dummy7',
                  type: 'dummy8',
                  issuedBy: const Author(''),
                ),
                [Translation('en', '')],
                [Translation('en', '')],
                CredentialStatusField.emptyCredentialStatusField(),
                [Evidence.emptyEvidence()],
              ),
              data: const {},
              display: Display.emptyDisplay(),
              image: '',
              shareLink: '',
            ),
            showBgDecoration: false,
          )
        : CredentialContainer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(image!),
                ),
              ),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: CustomMultiChildLayout(
                  delegate: CredentialBaseWidgetDelegate(position: Offset.zero),
                  children: [
                    if (title != null)
                      LayoutId(
                        id: 'title',
                        child: FractionallySizedBox(
                          widthFactor: 0.7,
                          heightFactor: 0.19,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: MyText(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .credentialBaseTitleText,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}
