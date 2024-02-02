import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class EnterpriseInitializationPage extends StatelessWidget {
  const EnterpriseInitializationPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const EnterpriseInitializationPage(),
      settings: const RouteSettings(name: '/EnterpriseInitializationPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EnterpriseInitializationCubit(
        client: DioClient('', Dio()),
        secureStorageProvider: getSecureStorage,
        jwtDecode: JWTDecode(),
        oidc4vc: OIDC4VC(),
        profileCubit: context.read<ProfileCubit>(),
      ),
      child: const EnterpriseInitializationView(),
    );
  }
}

class EnterpriseInitializationView extends StatefulWidget {
  const EnterpriseInitializationView({
    super.key,
  });

  @override
  State<EnterpriseInitializationView> createState() =>
      _EnterpriseInitializationViewState();
}

class _EnterpriseInitializationViewState
    extends State<EnterpriseInitializationView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.addListener(() {
      context
          .read<EnterpriseInitializationCubit>()
          .updateEmailFormat(emailController.text);
    });
    passwordController.addListener(() {
      context
          .read<EnterpriseInitializationCubit>()
          .updatePasswordFormat(passwordController.text);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<EnterpriseInitializationCubit,
        EnterpriseInitializationState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.status == AppStatus.success) {
          Navigator.of(context).pushReplacement<void, void>(
            ProtectWalletPage.route(routeType: WalletRouteType.create),
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
          title: l10n.initialization,
          titleAlignment: Alignment.topCenter,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: Sizes.space2XSmall),
              Text(
                l10n.pleaseEnterYourEmailAndYourCompanyPasswordToCreateYourAccount,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall3,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.walletProvider,
                style: Theme.of(context).textTheme.textFieldTitle,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).highlightColor,
                  border: Border.all(
                    color: Theme.of(context).highlightColor,
                    width: 0,
                  ),
                ),
                child: DropdownButton<WalletProviderType>(
                  value: state.walletProviderType,
                  underline: Container(),
                  dropdownColor: Theme.of(context).highlightColor,
                  isExpanded: true,
                  onChanged: (WalletProviderType? newValue) {
                    context
                        .read<EnterpriseInitializationCubit>()
                        .setWalletProviderType(newValue!);
                  },
                  items: WalletProviderType.values.map((type) {
                    return DropdownMenuItem<WalletProviderType>(
                      value: type,
                      child: Text(
                        type.formattedString,
                        style: Theme.of(context).textTheme.normal,
                      ),
                    );
                  }).toList(),
                  style: Theme.of(context).textTheme.normal,
                ),
              ),
              const SizedBox(height: Sizes.spaceSmall),
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
                              .read<EnterpriseInitializationCubit>()
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
                              .read<EnterpriseInitializationCubit>()
                              .requestTheConfiguration(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                        }
                      : null,
            ),
          ),
        );
      },
    );
  }
}
