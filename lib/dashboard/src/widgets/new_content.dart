import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class NewContent extends StatelessWidget {
  const NewContent({required this.version, required this.features, super.key});

  final String version;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: Sizes.spaceLarge,
            bottom: Sizes.spaceXSmall,
          ),
          child: Text(
            version,
            style: Theme.of(context).textTheme.newVersionTitle,
            textAlign: TextAlign.center,
          ),
        ),
        ListView.builder(
          itemCount: features.length,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.check_circle,
                      color: background,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      features[index],
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .defaultDialogBody
                          .copyWith(
                            color: background,
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
