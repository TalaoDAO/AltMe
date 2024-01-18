import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:secure_storage/secure_storage.dart';

class EnterpriseUpdatePage extends StatelessWidget {
  const EnterpriseUpdatePage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const EnterpriseUpdatePage(),
      settings: const RouteSettings(name: '/EnterpriseUpdatePage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EnterpriseUpdateCubit(
        client: DioClient('', Dio()),
        secureStorageProvider: getSecureStorage,
        jwtDecode: JWTDecode(),
        profileCubit: context.read<ProfileCubit>(),
      ),
      child: const EnterpriseUpdateView(),
    );
  }
}

class EnterpriseUpdateView extends StatefulWidget {
  const EnterpriseUpdateView({
    super.key,
  });

  @override
  State<EnterpriseUpdateView> createState() => _EnterpriseUpdateViewState();
}

class _EnterpriseUpdateViewState extends State<EnterpriseUpdateView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.addListener(() {
      context
          .read<EnterpriseUpdateCubit>()
          .updateEmailFormat(emailController.text);
    });
    passwordController.addListener(() {
      context
          .read<EnterpriseUpdateCubit>()
          .updatePasswordFormat(passwordController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<EnterpriseUpdateCubit, EnterpriseUpdateState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.status == AppStatus.success) {
          Navigator.popUntil(context, (route) {
            return route.settings.name == AltMeStrings.dashBoardPage;
          });
          showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => ConfirmDialog(
              title: l10n.congrats,
              subtitle: l10n.yourWalletConfigurationHasBeenSuccessfullyUpdated,
              yes: l10n.continueString,
              showNoButton: false,
              icon: IconStrings.tickCircle,
            ),
          );
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
          title: l10n.updateConfigurationNow,
          titleAlignment: Alignment.topCenter,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.pleaseEnterYourEmailAndPasswordToUpdateYourOrganizationWalletConfiguration,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall3,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.email,
                style: Theme.of(context).textTheme.textFieldTitle,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              BaseTextField(
                hint: l10n.yourEmail,
                fillColor: Theme.of(context).highlightColor,
                hintStyle: Theme.of(context).textTheme.hintTextFieldStyle,
                maxLines: 1,
                borderRadius: Sizes.normalRadius,
                controller: emailController,
                type: TextInputType.emailAddress,
                borderColor: Theme.of(context).colorScheme.background,
                suffixIcon: state.isEmailFormatCorrect
                    ? const Icon(Icons.check_circle)
                    : null,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.password,
                style: Theme.of(context).textTheme.textFieldTitle,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              BaseTextField(
                hint: l10n.password,
                fillColor: Theme.of(context).highlightColor,
                hintStyle: Theme.of(context).textTheme.hintTextFieldStyle,
                maxLines: 1,
                borderRadius: Sizes.normalRadius,
                controller: passwordController,
                type: TextInputType.text,
                obscureText: state.obscurePassword,
                borderColor: Theme.of(context).colorScheme.background,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: [
                      TransparentInkWell(
                        child: Icon(
                          state.obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onTap: () {
                          context
                              .read<EnterpriseUpdateCubit>()
                              .obscurePassword();
                        },
                      ),
                      if (state.isPasswordFormatCorrect) ...[
                        const SizedBox(width: 5),
                        const Icon(Icons.check_circle),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          navigation: Padding(
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: MyElevatedButton(
              text: l10n.next,
              onPressed:
                  state.isEmailFormatCorrect && state.isPasswordFormatCorrect
                      ? () async {
                          await context
                              .read<EnterpriseUpdateCubit>()
                              .updateTheConfiguration(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                          await context
                              .read<CredentialsCubit>()
                              .loadAllCredentials();
                        }
                      : null,
            ),
          ),
        );
      },
    );
  }
}
