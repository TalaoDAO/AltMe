import 'package:altme/app/shared/widget/image_from_network.dart';
import 'package:altme/home/home.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class OutputDescriptorWidget extends StatelessWidget {
  const OutputDescriptorWidget(
    this.outputDescriptor,
    this.item, {
    Key? key,
  }) : super(key: key);
  final List<OutputDescriptor> outputDescriptor;
  final CredentialModel item;
  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    for (final element in outputDescriptor) {
      final textcolor =
          getColorFromCredential(element.styles?.text, Colors.black);
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CredentialContainer(
            child: CredentialBackground(
              backgroundColor: getColorFromCredential(
                element.styles?.background,
                Colors.white,
              ),
              credentialModel: item,
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
                          element.display?.title,
                          item,
                          textcolor,
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
                    element.display?.subtitle,
                    item,
                    textcolor,
                  ),
                  DisplayMappingWidget(
                    element.display?.description,
                    item,
                    textcolor,
                  ),
                  DisplayPropertiesWidget(
                    element.display?.properties,
                    item,
                    textcolor,
                  ),
                ],
              ),
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
