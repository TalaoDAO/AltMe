import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ContactUsPage(),
      settings: const RouteSettings(name: '/ContactUsPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ContactUsView();
  }
}

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  late final formKey = GlobalKey<FormState>();
  String subject = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.contactUs,
      titleLeading: const BackLeadingButton(),
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.subject} :',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              height: Sizes.spaceXSmall,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.titleSmall,
              onSaved: (value) {
                subject = value ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.fillingThisFieldIsMandatory;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: '${l10n.subject} :',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      Sizes.smallRadius,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: Sizes.spaceLarge,
            ),
            Text(
              '${l10n.message} :',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              height: Sizes.spaceXSmall,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              maxLines: 6,
              style: Theme.of(context).textTheme.titleSmall,
              onSaved: (value) {
                message = value ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.fillingThisFieldIsMandatory;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: '${l10n.yourMessage} :',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      Sizes.smallRadius,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: MyElevatedButton(
          text: l10n.send,
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState?.save();
              try {
                await LaunchUrl.launch(
                  '''mailto:${AltMeStrings.appSupportMail}?subject=$subject&body=$message''',
                );
                Navigator.pop(context);
              } catch (_) {
                AlertMessage.showStateMessage(
                  context: context,
                  stateMessage: StateMessage.error(
                    stringMessage: l10n.failedToSendEmail,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
