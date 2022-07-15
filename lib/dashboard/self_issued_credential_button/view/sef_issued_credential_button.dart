import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef SelfIssuedCredentialButtonClick = SelfIssuedCredentialDataModel
    Function();

class SelfIssuedCredentialButton extends StatefulWidget {
  const SelfIssuedCredentialButton({
    Key? key,
    required this.selfIssuedCredentialButtonClick,
  }) : super(key: key);

  final SelfIssuedCredentialButtonClick selfIssuedCredentialButtonClick;

  @override
  State<SelfIssuedCredentialButton> createState() =>
      _SelfIssuedCredentialButtonState();
}

class _SelfIssuedCredentialButtonState
    extends State<SelfIssuedCredentialButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelfIssuedCredentialCubit,
        SelfIssuedCredentialButtonState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }
      },
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            if (state.status != AppStatus.loading) {
              context
                  .read<SelfIssuedCredentialCubit>()
                  .createSelfIssuedCredential(
                    selfIssuedCredentialDataModel:
                        widget.selfIssuedCredentialButtonClick.call(),
                  );
            }
          },
          child: const Icon(Icons.fact_check_outlined),
        );
      },
    );
  }
}
