import 'package:altme/app/shared/constants/image_strings.dart';
import 'package:altme/app/shared/enum/type/type.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class AcceptOidc4VpTransactionPage extends StatelessWidget {
  const AcceptOidc4VpTransactionPage({super.key});

  static Route<dynamic> route({
    required CredentialSubjectType credentialSubjectType,
    required Function onSelectPassbase,
    required Function onSelectKYC,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/AcceptOidc4VpTransactionPage'),
      builder: (_) => const AcceptOidc4VpTransactionPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.accept,
      titleLeading: const BackLeadingButton(),
      body: Column(children: [
        ],
      ),
    );
  }
}
