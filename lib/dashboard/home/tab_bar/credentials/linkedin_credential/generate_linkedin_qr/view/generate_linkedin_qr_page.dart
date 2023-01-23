import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:secure_storage/secure_storage.dart';

class GenerateLinkedinQrPage extends StatelessWidget {
  const GenerateLinkedinQrPage({
    super.key,
    required this.linkedinUrl,
  });

  final String linkedinUrl;

  static Route route({required String linkedinUrl}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/GenerateLinkedinQrPage'),
      builder: (_) => GenerateLinkedinQrPage(linkedinUrl: linkedinUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenerateLinkedInQrCubit(
        didKitProvider: DIDKitProvider(),
        secureStorageProvider: getSecureStorage,
      ),
      child: GenerateLinkedinQrView(linkedinUrl: linkedinUrl),
    );
  }
}

class GenerateLinkedinQrView extends StatefulWidget {
  const GenerateLinkedinQrView({
    super.key,
    required this.linkedinUrl,
  });

  final String linkedinUrl;

  @override
  State<GenerateLinkedinQrView> createState() => _GenerateLinkedinQrViewState();
}

class _GenerateLinkedinQrViewState extends State<GenerateLinkedinQrView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GenerateLinkedInQrCubit>()
          .generatePresentationForLinkedInCard(liinkedUrl: widget.linkedinUrl);
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
      padding: const EdgeInsets.only(
        top: 0,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        bottom: Sizes.spaceSmall,
      ),
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
        },
        builder: (context, state) {
          return Center(
            child: AspectRatio(
              aspectRatio: 1584 / 396,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(ImageStrings.linkedInBanner),
                  ),
                ),
                child: FractionallySizedBox(
                  heightFactor: 0.49,
                  widthFactor: 0.12,
                  child: CustomMultiChildLayout(
                    delegate: QrDelegate(
                      position: Offset.zero,
                    ),
                    children: [
                      LayoutId(
                        id: 'qr',
                        child: Center(
                          child: state.qrValue == null
                              ? Container()
                              : QrImage(
                                  data: state.qrValue!,
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
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
          onPressed: () async {},
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
      positionChild('qr', Offset(size.width * 3.145, size.height * -0.15));
    }
  }

  @override
  bool shouldRelayout(QrDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
