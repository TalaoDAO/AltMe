import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterpriseOTPPage extends StatelessWidget {
  const EnterpriseOTPPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const EnterpriseOTPPage(),
      settings: const RouteSettings(name: '/EnterpriseOTPPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EnterpriseOTPCubit(),
      child: EnterpriseOTPView(),
    );
  }
}

class EnterpriseOTPView extends StatelessWidget {
  EnterpriseOTPView({super.key});

  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<EnterpriseOTPCubit, EnterpriseOTPState>(
      listener: (context, state) async {
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
        return BasePage(
          scrollView: true,
          useSafeArea: true,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
          titleLeading: const BackLeadingButton(),
          backgroundColor: Theme.of(context).colorScheme.drawerBackground,
          title: l10n.login,
          titleAlignment: Alignment.topCenter,
          body: Column(
            children: <Widget>[
              const SizedBox(height: Sizes.space2XSmall),
              const MStepper(step: 1, totalStep: 2),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.enterTheSecurityCodeThatWeSentYouByEmail,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall3,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              const SizedBox(height: Sizes.spaceNormal),

              ///OTP Box
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OtpTextField(
                      index: 0,
                      controllers: _controllers,
                      autoFocus: true,
                    ),
                    const SizedBox(width: 15),
                    OtpTextField(
                      index: 1,
                      controllers: _controllers,
                    ),
                    const SizedBox(width: 15),
                    OtpTextField(
                      index: 2,
                      controllers: _controllers,
                    ),
                    const SizedBox(width: 15),
                    OtpTextField(
                      index: 3,
                      controllers: _controllers,
                    ),
                  ],
                ),
              ),
            ],
          ),
          navigation: Padding(
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: MyElevatedButton(
              text: l10n.next,
              onPressed: null,
            ),
          ),
        );
      },
    );
  }
}
