import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CredentialDynamicDetial extends StatelessWidget {
  const CredentialDynamicDetial({
    Key? key,
    required this.title,
    required this.value,
    this.titleColor,
    this.valueColor,
    this.padding = const EdgeInsets.all(8),
    required this.format,
  }) : super(key: key);

  final String? title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;
  final EdgeInsetsGeometry padding;
  final String? format;

  @override
  Widget build(BuildContext context) {
    String valueData = value;

    if (format != null) {
      if (format == AltMeStrings.date) {
        if (DateTime.tryParse(value) != null) {
          final DateTime dt = DateTime.parse(value);
          valueData = UiDate.formatDateTime(dt);
        }
      }

      if (format == AltMeStrings.time) {
        final String? time = UiDate.formatTime(value);
        if (time != null) {
          valueData = time;
        }
      }
    }

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
                if (format != null) {
                  if (format == AltMeStrings.uri) {
                    await LaunchUrl.launch(valueData);
                  } else if (format == AltMeStrings.email) {
                    await LaunchUrl.launch('mailto:$valueData');
                  }
                }
              },
              child: Text(
                valueData,
                style: (format != null &&
                        (format == AltMeStrings.uri ||
                            format == AltMeStrings.email))
                    ? valueTheme.copyWith(
                        color: Theme.of(context).colorScheme.markDownA,
                        decoration: TextDecoration.underline,
                      )
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
