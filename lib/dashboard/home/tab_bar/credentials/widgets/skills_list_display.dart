import 'package:altme/dashboard/home/tab_bar/credentials/models/professional_experience_assessment/skill.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class SkillsListDisplay extends StatelessWidget {
  const SkillsListDisplay({required this.skillWidgetList, Key? key})
      : super(key: key);

  final List<Skill> skillWidgetList;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = skillWidgetList
        .map(
          (Skill skill) => Row(
            children: [
              const Icon(Icons.arrow_right_alt_sharp),
              Text(
                skill.description,
                style: Theme.of(context).textTheme.credentialFieldDescription,
              ),
            ],
          ),
        )
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
