import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/selective_disclosure/widget/display_selective_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsumeSelectiveDisclosureCubit extends StatelessWidget {
  const ConsumeSelectiveDisclosureCubit({
    super.key,
    required this.credentialModel,
    required this.showVertically,
    this.onPressed,
    this.parentKeyId,
  });

  final CredentialModel credentialModel;
  final bool showVertically;
  final void Function(String?, String, String?, String?)? onPressed;

  final String? parentKeyId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectiveDisclosureCubit, SelectiveDisclosureState>(
      builder: (context, state) {
        return DisplaySelectiveDisclosure(
          credentialModel: credentialModel,
          selectiveDisclosureState: state,
          onPressed: onPressed,
          showVertically: true,
        );
      },
    );
  }
}
