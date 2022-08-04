import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CredentialDynamicDetial extends StatelessWidget {
  const CredentialDynamicDetial({
    Key? key,
    required this.title,
    required this.value,
    this.titleColor,
    this.valueColor,
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);

  final String? title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    String valueData = value;

    if (DateTime.tryParse(value) != null) {
      final DateTime dt = DateTime.parse(value);
      valueData = UiDate.formatDateTime(dt);
    }

    final bool isValidURL = Uri.parse(valueData).isAbsolute;
    final bool isEmail = valueData.isValidEmail();

    final textTheme = Theme.of(context).textTheme;

    final titleTheme = titleColor == null
        ? textTheme.credentialFieldTitle
        : textTheme.credentialFieldTitle.copyWith(color: titleColor);

    final valueTheme = valueColor == null
        ? Theme.of(context).textTheme.credentialFieldDescription
        : Theme.of(context)
            .textTheme
            .credentialFieldDescription
            .copyWith(color: valueColor);

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: titleTheme,
          ),
          Flexible(
            child: TransparentInkWell(
              onTap: () async {
                if (isValidURL) {
                  await LaunchUrl.launch(valueData);
                } else if (isEmail) {
                  await LaunchUrl.launch('mailto:$valueData');
                }
              },
              child: Text(
                valueData,
                style: isValidURL || isEmail
                    ? valueTheme.copyWith(decoration: TextDecoration.underline)
                    : valueTheme,
                maxLines: 5,
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
