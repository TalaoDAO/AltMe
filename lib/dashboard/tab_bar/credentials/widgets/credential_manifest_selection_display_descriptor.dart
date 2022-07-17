import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class CredentialSelectionManifestDisplayDescriptor extends StatelessWidget {
  const CredentialSelectionManifestDisplayDescriptor({
    Key? key,
    required this.credentialModel,
    required this.outputDescriptors,
    required this.showBgDecoration,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final List<OutputDescriptor> outputDescriptors;
  final bool showBgDecoration;

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    for (final element in outputDescriptors) {
      final textcolor =
          getColorFromCredential(element.styles?.text, Colors.black);
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CredentialBackground(
            showBgDecoration: false,
            backgroundColor: getColorFromCredential(
              element.styles?.background,
              Colors.white,
            ),
            credentialModel: credentialModel,
            child: Column(
              children: [
                if (element.styles?.hero != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ImageFromNetwork(element.styles!.hero!.uri),
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  children: [
                    Expanded(
                      child: DisplayMappingWidget(
                        displayMapping: element.display?.title,
                        credentialModel: credentialModel,
                        textColor: textcolor,
                      ),
                    ),
                    if (element.styles?.thumbnail != null)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxHeight: 100,
                            maxWidth: 100,
                          ),
                          child: ImageFromNetwork(
                            element.styles!.thumbnail!.uri,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
                DisplayMappingWidget(
                  displayMapping: element.display?.subtitle,
                  credentialModel: credentialModel,
                  textColor: textcolor,
                ),
                DisplayMappingWidget(
                  displayMapping: element.display?.description,
                  credentialModel: credentialModel,
                  textColor: textcolor,
                ),
                DisplayPropertiesWidget(
                  properties: element.display?.properties,
                  credentialModel: credentialModel,
                  textColor: textcolor,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      children: widgets,
    );
  }
}
