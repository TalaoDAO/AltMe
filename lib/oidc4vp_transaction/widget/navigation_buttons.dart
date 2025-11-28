import 'package:altme/oidc4vp_transaction/widget/accept_button.dart';
import 'package:altme/oidc4vp_transaction/widget/refuse_button.dart';
import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 143,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(padding: EdgeInsets.all(8), child: AcceptButton()),
          Padding(padding: EdgeInsets.all(8), child: RefuseButton()),
        ],
      ),
    );
  }
}
