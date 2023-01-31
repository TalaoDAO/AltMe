import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileCheckboxCubit()),
        BlocProvider(
          create: (_) => SelfIssuedCredentialCubit(
            walletCubit: context.read<WalletCubit>(),
            secureStorageProvider: getSecureStorage,
            didKitProvider: DIDKitProvider(),
            didCubit: context.read<DIDCubit>(),
          ),
        ),
      ],
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<ProfileView> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController emailController;
  late TextEditingController companyNameController;
  late TextEditingController companyWebsiteController;
  late TextEditingController jobTitleController;

  late final l10n = context.l10n;
  late final profileCheckboxCubit = context.read<ProfileCheckboxCubit>();

  late final profileCubit = context.read<ProfileCubit>();

  late final isEnterprise = profileCubit.state.model.isEnterprise;

  @override
  void initState() {
    super.initState();

    firstNameController =
        TextEditingController(text: profileCubit.state.model.firstName);
    lastNameController =
        TextEditingController(text: profileCubit.state.model.lastName);
    phoneController =
        TextEditingController(text: profileCubit.state.model.phone);
    locationController =
        TextEditingController(text: profileCubit.state.model.location);
    emailController =
        TextEditingController(text: profileCubit.state.model.email);
    //enterprise
    companyNameController =
        TextEditingController(text: profileCubit.state.model.companyName);
    companyWebsiteController =
        TextEditingController(text: profileCubit.state.model.companyWebsite);
    jobTitleController =
        TextEditingController(text: profileCubit.state.model.jobTitle);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: l10n.profileTitle,
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, profileState) {
          if (profileState.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: profileState.message!,
            );
          }
        },
        child: BlocListener<SelfIssuedCredentialCubit,
            SelfIssuedCredentialButtonState>(
          listener: (context, selfIssuedCredentialState) {
            if (selfIssuedCredentialState.status == AppStatus.loading) {
              LoadingView().show(context: context);
            } else {
              LoadingView().hide();
            }
          },
          child: BlocBuilder<ProfileCheckboxCubit, ProfileCheckboxState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  BackgroundCard(
                    child: Column(
                      children: [
                        Text(
                          l10n.personalSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.infoTitle,
                        ),
                        const SizedBox(height: 32),
                        BaseTextField(
                          label: l10n.personalFirstName,
                          controller: firstNameController,
                          suffixIcon: ImageIcon(
                            const AssetImage(IconStrings.profileCircle),
                            color: state.isFirstName
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onTertiary,
                          ),
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: isEnterprise
                              ? null
                              : Checkbox(
                                  value: state.isFirstName,
                                  fillColor: MaterialStateProperty.all(
                                    state.isFirstName
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                  ),
                                  checkColor:
                                      Theme.of(context).colorScheme.background,
                                  onChanged: (value) => profileCheckboxCubit
                                      .firstNameCheckBoxChange(
                                    value: value,
                                  ),
                                ),
                        ),
                        _textFieldSpace(),
                        BaseTextField(
                          label: l10n.personalLastName,
                          controller: lastNameController,
                          suffixIcon: Icon(
                            Icons.person,
                            color: state.isLastName
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onTertiary,
                          ),
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: isEnterprise
                              ? null
                              : Checkbox(
                                  value: state.isLastName,
                                  fillColor: MaterialStateProperty.all(
                                    state.isLastName
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                  ),
                                  checkColor:
                                      Theme.of(context).colorScheme.background,
                                  onChanged: (value) => profileCheckboxCubit
                                      .lastNameCheckBoxChange(value: value),
                                ),
                        ),
                        _textFieldSpace(),
                        BaseTextField(
                          label: l10n.personalPhone,
                          controller: phoneController,
                          suffixIcon: ImageIcon(
                            const AssetImage(IconStrings.call),
                            color: state.isPhone
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onTertiary,
                          ),
                          type: TextInputType.phone,
                          prefixIcon: isEnterprise
                              ? null
                              : Checkbox(
                                  value: state.isPhone,
                                  fillColor: MaterialStateProperty.all(
                                    state.isPhone
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                  ),
                                  checkColor:
                                      Theme.of(context).colorScheme.background,
                                  onChanged: (value) => profileCheckboxCubit
                                      .phoneCheckBoxChange(value: value),
                                ),
                        ),
                        _textFieldSpace(),
                        BaseTextField(
                          label: l10n.personalMail,
                          controller: emailController,
                          suffixIcon: ImageIcon(
                            const AssetImage(IconStrings.sms),
                            color: state.isEmail
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onTertiary,
                          ),
                          type: TextInputType.emailAddress,
                          prefixIcon: isEnterprise
                              ? null
                              : Checkbox(
                                  value: state.isEmail,
                                  fillColor: MaterialStateProperty.all(
                                    state.isEmail
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                  ),
                                  checkColor:
                                      Theme.of(context).colorScheme.background,
                                  onChanged: (value) => profileCheckboxCubit
                                      .emailCheckBoxChange(value: value),
                                ),
                        ),
                        _textFieldSpace(),
                        BaseTextField(
                          label: l10n.personalAddress,
                          controller: locationController,
                          suffixIcon: ImageIcon(
                            const AssetImage(IconStrings.location),
                            color: state.isLocation
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onTertiary,
                          ),
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: isEnterprise
                              ? null
                              : Checkbox(
                                  value: state.isLocation,
                                  fillColor: MaterialStateProperty.all(
                                    state.isLocation
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                  ),
                                  checkColor:
                                      Theme.of(context).colorScheme.background,
                                  onChanged: (value) => profileCheckboxCubit
                                      .locationCheckBoxChange(value: value),
                                ),
                        ),
                        _textFieldSpace(),
                        if (isEnterprise) _buildEnterpriseTextFields(state),
                      ],
                    ),
                  ),
                  _textFieldSpace(),
                  MyOutlinedButton.icon(
                    text: l10n.personalSave,
                    icon: ImageIcon(
                      const AssetImage(IconStrings.folderOpen),
                      color: Theme.of(context).colorScheme.onOutlineButton,
                    ),
                    onPressed: () async {
                      if (context
                              .read<SelfIssuedCredentialCubit>()
                              .state
                              .status ==
                          AppStatus.loading) return;

                      await _updateProfile();
                      AlertMessage.showStateMessage(
                        context: context,
                        stateMessage: StateMessage.success(
                          stringMessage: l10n.succesfullyUpdated,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  _textFieldSpace(),
                  MyElevatedButton(
                    text: l10n.generate,
                    onPressed: () async {
                      if (context
                              .read<SelfIssuedCredentialCubit>()
                              .state
                              .status ==
                          AppStatus.loading) return;

                      await _updateProfile();

                      await context
                          .read<SelfIssuedCredentialCubit>()
                          .createSelfIssuedCredential(
                            selfIssuedCredentialDataModel:
                                _getSelfIssuedCredential(),
                          );
                      AlertMessage.showStateMessage(
                        context: context,
                        stateMessage: StateMessage.success(
                          stringMessage: l10n.succesfullyUpdated,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    final model = profileCubit.state.model.copyWith(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phone: phoneController.text,
      location: locationController.text,
      email: emailController.text,
      companyName: companyNameController.text,
      companyWebsite: companyWebsiteController.text,
      jobTitle: jobTitleController.text,
      issuerVerificationUrl: profileCubit.state.model.issuerVerificationUrl,
    );

    await context.read<ProfileCubit>().update(model);
  }

  SelfIssuedCredentialDataModel _getSelfIssuedCredential() {
    final selfIssuedCredentialDataModel = SelfIssuedCredentialDataModel(
      givenName: profileCheckboxCubit.state.isFirstName
          ? firstNameController.text.isNotEmpty
              ? firstNameController.text
              : null
          : null,
      familyName: profileCheckboxCubit.state.isLastName
          ? lastNameController.text.isNotEmpty
              ? lastNameController.text
              : null
          : null,
      telephone: profileCheckboxCubit.state.isPhone
          ? phoneController.text.isNotEmpty
              ? phoneController.text
              : null
          : null,
      address: profileCheckboxCubit.state.isLocation
          ? locationController.text
          : null,
      email: profileCheckboxCubit.state.isEmail ? emailController.text : null,
      companyName: profileCheckboxCubit.state.isCompanyName
          ? companyNameController.text
          : null,
      companyWebsite: profileCheckboxCubit.state.isCompanyWebsite
          ? companyWebsiteController.text
          : null,
      jobTitle: profileCheckboxCubit.state.isJobTitle
          ? jobTitleController.text
          : null,
    );

    return selfIssuedCredentialDataModel;
  }

  Widget _textFieldSpace() {
    return const SizedBox(height: 16);
  }

  Widget _buildEnterpriseTextFields(ProfileCheckboxState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _textFieldSpace(),
        BaseTextField(
          label: l10n.companyName,
          controller: companyNameController,
          suffixIcon: Icon(
            Icons.apartment,
            color: state.isCompanyName
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onTertiary,
          ),
          type: TextInputType.text,
          prefixIcon: isEnterprise
              ? null
              : Checkbox(
                  value: state.isCompanyName,
                  fillColor: MaterialStateProperty.all(
                    state.isCompanyName
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onTertiary,
                  ),
                  checkColor: Theme.of(context).colorScheme.background,
                  onChanged: (value) => profileCheckboxCubit
                      .companyNameCheckBoxChange(value: value),
                ),
        ),
        _textFieldSpace(),
        BaseTextField(
          label: l10n.companyWebsite,
          controller: companyWebsiteController,
          suffixIcon: Icon(
            Icons.web_outlined,
            color: state.isCompanyWebsite
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onTertiary,
          ),
          type: TextInputType.url,
          prefixIcon: isEnterprise
              ? null
              : Checkbox(
                  value: state.isCompanyWebsite,
                  fillColor: MaterialStateProperty.all(
                    state.isCompanyWebsite
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onTertiary,
                  ),
                  checkColor: Theme.of(context).colorScheme.background,
                  onChanged: (value) => profileCheckboxCubit
                      .companyWebsiteCheckBoxChange(value: value),
                ),
        ),
        _textFieldSpace(),
        BaseTextField(
          label: l10n.jobTitle,
          controller: jobTitleController,
          type: TextInputType.text,
          suffixIcon: Icon(
            Icons.work_outlined,
            color: state.isJobTitle
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onTertiary,
          ),
          prefixIcon: isEnterprise
              ? null
              : Checkbox(
                  value: state.isJobTitle,
                  fillColor: MaterialStateProperty.all(
                    state.isJobTitle
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onTertiary,
                  ),
                  checkColor: Theme.of(context).colorScheme.background,
                  onChanged: (value) =>
                      profileCheckboxCubit.jobTitleCheckBoxChange(value: value),
                ),
        ),
        _textFieldSpace()
      ],
    );
  }
}
