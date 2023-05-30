import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:polygonid/polygonid.dart';

class PolygonIdProofPage extends StatelessWidget {
  const PolygonIdProofPage({
    super.key,
    required this.claimEntity,
  });

  final ClaimEntity claimEntity;

  static Route<dynamic> route({
    required ClaimEntity claimEntity,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => PolygonIdProofPage(
          claimEntity: claimEntity,
        ),
        settings: const RouteSettings(name: '/PolygonIdProofPage'),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(all): change UI
    return BasePage(
      useSafeArea: true,
      titleLeading: const BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CredentialContainer(
            child: AspectRatio(
              aspectRatio: Sizes.credentialAspectRatio,
              child: DecoratedBox(
                decoration: BaseBoxDecoration(
                  color: Theme.of(context).colorScheme.credentialBackground,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff0B67C5),
                      Color(0xff200072),
                    ],
                  ),
                  shapeColor: Theme.of(context).colorScheme.documentShape,
                  value: 1,
                  anchors: const <Alignment>[],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                separateUppercaseWords(claimEntity.type),
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              Text(
                                'PROOF',
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.grey.withOpacity(0.9),
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.warning,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  'No information will be shared from this '
                                  'credential, '
                                  'only the private proof.',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
