import 'package:altme/credentials/credential.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class SkillsListDisplay extends StatelessWidget {
  const SkillsListDisplay({required this.skillWidgetList, Key? key})
      : super(key: key);

  final List<SkillModel> skillWidgetList;

  @override
  Widget build(BuildContext context) {
    final widgetList = skillWidgetList
        .map((e) => Row(
              children: [
                const Icon(Icons.arrow_right_alt_sharp),
                Text(
                  e.description,
                  style: Theme.of(context).textTheme.credentialFieldDescription,
                ),
              ],
            ))
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgetList,
      ),
    );
  }
}
