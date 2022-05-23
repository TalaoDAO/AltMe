import 'package:altme/app/app.dart';
import 'package:altme/app/shared/widget/button/button.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/credentials/credential.dart';
import 'package:altme/home/drawer/drawer/view/widget/drawer_item.dart';
import 'package:altme/home/drawer/profile/cubit/profile_checkbox_cubit.dart';
import 'package:altme/home/drawer/profile/cubit/profile_cubit.dart';
import 'package:altme/home/drawer/profile/models/profile.dart';
import 'package:altme/home/nft/view/nft_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/self_issued_credential_button/sef_issued_credential_button.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.profileModel,
    required this.isFromOnBoarding,
  }) : super(key: key);

  final ProfileModel profileModel;
  final bool isFromOnBoarding;

  static Route route({
    required ProfileModel profileModel,
    required bool isFromOnBoarding,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => MultiBlocProvider(
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
          child: ProfilePage(
            profileModel: profileModel,
            isFromOnBoarding: isFromOnBoarding,
          ),
        ),
        settings: const RouteSettings(name: '/personalPage'),
      );

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<ProfilePage> {
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
  late final isEnterprise = widget.profileModel.isEnterprise;

  @override
  void initState() {
    super.initState();

    firstNameController =
        TextEditingController(text: widget.profileModel.firstName);
    lastNameController =
        TextEditingController(text: widget.profileModel.lastName);
    phoneController = TextEditingController(text: widget.profileModel.phone);
    locationController =
        TextEditingController(text: widget.profileModel.location);
    emailController = TextEditingController(text: widget.profileModel.email);
    //enterprise
    companyNameController =
        TextEditingController(text: widget.profileModel.companyName);
    companyWebsiteController =
        TextEditingController(text: widget.profileModel.companyWebsite);
    jobTitleController =
        TextEditingController(text: widget.profileModel.jobTitle);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!widget.isFromOnBoarding) {
          if (context.read<SelfIssuedCredentialCubit>().state.status !=
              AppStatus.loading) {
            Navigator.of(context).pop();
          }
        }
        return false;
      },
      child: BasePage(
        title: l10n.profileTitle,
        titleLeading:
            widget.isFromOnBoarding ? null : const BackLeadingButton(),
        padding: const EdgeInsets.symmetric(
          vertical: 32,
        ),
        body: BlocBuilder<ProfileCheckboxCubit, ProfileCheckboxState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      l10n.personalSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.subtitle1,
                          ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  BaseTextField(
                    label: l10n.personalFirstName,
                    controller: firstNameController,
                    icon: Icons.person,
                    textCapitalization: TextCapitalization.words,
                    prefixIcon: isEnterprise && widget.isFromOnBoarding
                        ? null
                        : Checkbox(
                            value: state.isFirstName,
                            fillColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondaryContainer,
                            ),
                            onChanged: (value) => profileCheckboxCubit
                                .firstNameCheckBoxChange(value: value),
                          ),
                  ),
                  _textFieldSpace(),
                  BaseTextField(
                    label: l10n.personalLastName,
                    controller: lastNameController,
                    icon: Icons.person,
                    textCapitalization: TextCapitalization.words,
                    prefixIcon: isEnterprise && widget.isFromOnBoarding
                        ? null
                        : Checkbox(
                            value: state.isLastName,
                            fillColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondaryContainer,
                            ),
                            onChanged: (value) => profileCheckboxCubit
                                .lastNameCheckBoxChange(value: value),
                          ),
                  ),
                  _textFieldSpace(),
                  BaseTextField(
                    label: l10n.personalPhone,
                    controller: phoneController,
                    icon: Icons.phone,
                    type: TextInputType.phone,
                    prefixIcon: isEnterprise && widget.isFromOnBoarding
                        ? null
                        : Checkbox(
                            value: state.isPhone,
                            fillColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondaryContainer,
                            ),
                            onChanged: (value) => profileCheckboxCubit
                                .phoneCheckBoxChange(value: value),
                          ),
                  ),
                  _textFieldSpace(),
                  BaseTextField(
                    label: l10n.personalLocation,
                    controller: locationController,
                    icon: Icons.location_pin,
                    textCapitalization: TextCapitalization.words,
                    prefixIcon: isEnterprise && widget.isFromOnBoarding
                        ? null
                        : Checkbox(
                            value: state.isLocation,
                            fillColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondaryContainer,
                            ),
                            onChanged: (value) => profileCheckboxCubit
                                .locationCheckBoxChange(value: value),
                          ),
                  ),
                  _textFieldSpace(),
                  BaseTextField(
                    label: l10n.personalMail,
                    controller: emailController,
                    icon: Icons.email,
                    type: TextInputType.emailAddress,
                    prefixIcon: isEnterprise && widget.isFromOnBoarding
                        ? null
                        : Checkbox(
                            value: state.isEmail,
                            fillColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondaryContainer,
                            ),
                            onChanged: (value) => profileCheckboxCubit
                                .emailCheckBoxChange(value: value),
                          ),
                  ),
                  DrawerItem(
                    key: const Key('my_nft'),
                    icon: Icons.videogame_asset,
                    title: 'NFT assets',
                    onTap: () =>
                        Navigator.of(context).push<void>(NftPage.route()),
                  ),
                  _textFieldSpace(),
                  if (isEnterprise) _buildEnterpriseTextFields(state),
                  MyOutlinedButton(
                    text: l10n.personalSave,
                    onPressed: () async {
                      if (context
                              .read<SelfIssuedCredentialCubit>()
                              .state
                              .status ==
                          AppStatus.loading) return;
                      final model = widget.profileModel.copyWith(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        phone: phoneController.text,
                        location: locationController.text,
                        email: emailController.text,
                        companyName: companyNameController.text,
                        companyWebsite: companyWebsiteController.text,
                        jobTitle: jobTitleController.text,
                        issuerVerificationSetting:
                            widget.profileModel.issuerVerificationSetting,
                      );

                      await context.read<ProfileCubit>().update(model);
                      if (widget.isFromOnBoarding) {
                        ///save selfIssued credential when user press save button
                        /// during onBoarding
                        await context
                            .read<SelfIssuedCredentialCubit>()
                            .createSelfIssuedCredential(
                              selfIssuedCredentialDataModel:
                                  _getSelfIssuedCredential(),
                            );
                        await Navigator.of(context).pushReplacement<void, void>(
                          CredentialsListPage.route(),
                        );
                      } else {
                        AlertMessage.showStringMessage(
                          context: context,
                          message: l10n.succesfullyUpdated,
                          messageType: MessageType.success,
                        );

                        Navigator.of(context).pop();

                        /// Another pop to close the drawer
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  _textFieldSpace(),
                  MyElevatedButton(
                    text: l10n.generate,
                    onPressed: () => _getSelfIssuedCredential,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
          icon: Icons.apartment,
          type: TextInputType.text,
          prefixIcon: isEnterprise && widget.isFromOnBoarding
              ? null
              : Checkbox(
                  value: state.isCompanyName,
                  fillColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onChanged: (value) => profileCheckboxCubit
                      .companyNameCheckBoxChange(value: value),
                ),
        ),
        _textFieldSpace(),
        BaseTextField(
          label: l10n.companyWebsite,
          controller: companyWebsiteController,
          icon: Icons.web_outlined,
          type: TextInputType.url,
          prefixIcon: isEnterprise && widget.isFromOnBoarding
              ? null
              : Checkbox(
                  value: state.isCompanyWebsite,
                  fillColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onChanged: (value) => profileCheckboxCubit
                      .companyWebsiteCheckBoxChange(value: value),
                ),
        ),
        _textFieldSpace(),
        BaseTextField(
          label: l10n.jobTitle,
          controller: jobTitleController,
          icon: Icons.work_outlined,
          type: TextInputType.text,
          prefixIcon: isEnterprise && widget.isFromOnBoarding
              ? null
              : Checkbox(
                  value: state.isJobTitle,
                  fillColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onChanged: (value) =>
                      profileCheckboxCubit.jobTitleCheckBoxChange(value: value),
                ),
        ),
        _textFieldSpace()
      ],
    );
  }
}
