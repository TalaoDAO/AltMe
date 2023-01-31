import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/did/did.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:did_kit/did_kit.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:secure_storage/secure_storage.dart';

class GenerateLinkedinQrPage extends StatelessWidget {
  const GenerateLinkedinQrPage({
    super.key,
    required this.linkedinUrl,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;
  final String linkedinUrl;

  static Route<dynamic> route({
    required String linkedinUrl,
    required CredentialModel credentialModel,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/GenerateLinkedinQrPage'),
      builder: (_) => GenerateLinkedinQrPage(
        linkedinUrl: linkedinUrl,
        credentialModel: credentialModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenerateLinkedInQrCubit(
        didKitProvider: DIDKitProvider(),
        secureStorageProvider: getSecureStorage,
        fileSaver: FileSaver.instance,
        didCubit: context.read<DIDCubit>(),
      ),
      child: GenerateLinkedinQrView(
        linkedinUrl: linkedinUrl,
        credentialModel: credentialModel,
      ),
    );
  }
}

class GenerateLinkedinQrView extends StatefulWidget {
  const GenerateLinkedinQrView({
    super.key,
    required this.linkedinUrl,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;
  final String linkedinUrl;

  @override
  State<GenerateLinkedinQrView> createState() => _GenerateLinkedinQrViewState();
}

class _GenerateLinkedinQrViewState extends State<GenerateLinkedinQrView> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GenerateLinkedInQrCubit>()
          .generatePresentationForLinkedInCard(
            linkedInUrl: widget.linkedinUrl,
            credentialModel: widget.credentialModel,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.linkedInBanner,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      body: BlocConsumer<GenerateLinkedInQrCubit, GenerateLinkedInQrState>(
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

          if (state.status == AppStatus.success) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Center(
            child: Screenshot<dynamic>(
              controller: screenshotController,
              child: AspectRatio(
                aspectRatio: Sizes.linkedinBannerAspectRatio,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(ImageStrings.linkedInBanner),
                    ),
                  ),
                  child: CustomMultiChildLayout(
                    delegate: QrDelegate(position: Offset.zero),
                    children: [
                      LayoutId(
                        id: 'qr',
                        child: state.qrValue == null
                            ? Container()
                            : FractionallySizedBox(
                                heightFactor: 0.48,
                                widthFactor: 0.12,
                                child: PrettyQr(
                                  size: 300,
                                  data: state.qrValue!,
                                  errorCorrectLevel: QrErrorCorrectLevel.M,
                                  typeNumber: null,
                                  roundEdges: true,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: MyElevatedButton(
          text: l10n.exportToLinkedIn,
          onPressed: () async {
            final log =
                getLogger('GenerateLinkedinQrView - screenshotController');
            await screenshotController
                .capture(delay: const Duration(milliseconds: 10))
                .then((capturedImage) {
              context
                  .read<GenerateLinkedInQrCubit>()
                  .saveScreenshot(capturedImage!);
            }).catchError((dynamic onError) {
              log.e(onError);
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: StateMessage.error(
                  stringMessage: l10n.somethingsWentWrongTryAgainLater,
                ),
              );
            });
          },
        ),
      ),
    );
  }
}

class QrDelegate extends MultiChildLayoutDelegate {
  QrDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('qr')) {
      layoutChild('qr', BoxConstraints.loose(size));
      positionChild('qr', Offset(size.width * 0.8175, size.height * 0.185));
    }
  }

  @override
  bool shouldRelayout(QrDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
