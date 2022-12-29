import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/submit_enterprise_user/cubit/submit_enterprise_user_cubit.dart';
import 'package:altme/onboarding/submit_enterprise_user/view/widgets/pick_file_button.dart';
import 'package:altme/onboarding/submit_enterprise_user/view/widgets/picked_file.dart';
import 'package:did_kit/did_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_storage/secure_storage.dart';

class SubmitEnterpriseUserPage extends StatelessWidget {
  const SubmitEnterpriseUserPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const SubmitEnterpriseUserPage(),
        settings: const RouteSettings(name: '/submitEnterpriseUserPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubmitEnterpriseUserCubit(
        secureStorageProvider: getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
      ),
      child: const SubmitEnterpriseUserView(),
    );
  }
}

class SubmitEnterpriseUserView extends StatefulWidget {
  const SubmitEnterpriseUserView({Key? key}) : super(key: key);

  @override
  _SubmitEnterpriseUserViewState createState() =>
      _SubmitEnterpriseUserViewState();
}

class _SubmitEnterpriseUserViewState extends State<SubmitEnterpriseUserView> {
  late final TextEditingController _didController = TextEditingController();

  @override
  void initState() {
    _didController.text = 'did:web:';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.l10n;
    return BlocConsumer<SubmitEnterpriseUserCubit, SubmitEnterpriseUserState>(
      listener: (context, state) async {
        if (state.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );

          if (state.status == AppStatus.success) {
            final model = ProfileModel.empty().copyWith(isEnterprise: true);
            await context.read<ProfileCubit>().update(model);

            /// Removes every stack except first route (splashPage)
            await Navigator.pushAndRemoveUntil<void>(
              context,
              DashboardPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          }
        }
      },
      builder: (context, state) {
        return BasePage(
          title: localization.submit,
          titleLeading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                localization.insertYourDIDKey,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(
                height: 20,
              ),
              BaseTextField(
                controller: _didController,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                localization.importYourRSAKeyJsonFile,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(
                height: 20,
              ),
              if (state.rsaFile == null)
                PickFileButton(onTap: () => _pickRSAJsonFile(localization))
              else
                PickedFile(
                  fileName: state.rsaFile!.name,
                  onDeleteButtonPress: () {
                    context.read<SubmitEnterpriseUserCubit>().setRSAFile(null);
                  },
                ),
            ],
          ),
          navigation: Container(
            margin: const EdgeInsets.all(15),
            child: MyElevatedButton(
              onPressed: () {
                context
                    .read<SubmitEnterpriseUserCubit>()
                    .verify(_didController.text);
              },
              text: localization.confirm,
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickRSAJsonFile(AppLocalizations l10n) async {
    final storagePermission = await Permission.storage.request();
    if (storagePermission.isDenied) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: StateMessage.success(
          stringMessage: l10n.storagePermissionDeniedMessage,
        ),
      );
      return;
    }

    if (storagePermission.isPermanentlyDenied) {
      await _showPermissionPopup();
      return;
    }

    if (storagePermission.isGranted || storagePermission.isLimited) {
      final pickedFiles = await FilePicker.platform.pickFiles(
        dialogTitle: l10n.pleaseSelectRSAKeyFileWithJsonExtension,
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['json', 'txt'],
      );
      if (pickedFiles != null) {
        context
            .read<SubmitEnterpriseUserCubit>()
            .setRSAFile(pickedFiles.files.first);
      }
    }
  }

  Future<void> _showPermissionPopup() async {
    final l10n = context.l10n;
    final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmDialog(
            title: l10n.storagePermissionRequired,
            subtitle: l10n.storagePermissionPermanentlyDeniedMessage,
            yes: l10n.ok,
            no: l10n.cancel,
          ),
        ) ??
        false;

    if (confirm) {
      await openAppSettings();
    }
  }
}
