import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DummyCredentialImage extends StatelessWidget {
  const DummyCredentialImage({
    required this.discoverDummyCredential,
    this.aspectRatio = Sizes.credentialAspectRatio,
    super.key,
  });

  final DiscoverDummyCredential discoverDummyCredential;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    String? title;

    if (discoverDummyCredential.credentialSubjectType ==
        CredentialSubjectType.employeeCredential) {
      title = discoverDummyCredential.credentialSubjectType.title;
    }

    return CredentialContainer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(discoverDummyCredential.image!),
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
                        style:
                            Theme.of(context).textTheme.identitiyBaseTitleText,
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
