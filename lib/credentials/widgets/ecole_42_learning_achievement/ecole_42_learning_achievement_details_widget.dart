import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class Ecole42LearningAchievementDetailsWidget extends StatelessWidget {
  const Ecole42LearningAchievementDetailsWidget(
      {Key? key, required this.model, this.imageUrl = ''})
      : super(key: key);

  final Ecole42LearningAchievementModel model;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    const _height = 1753.0;
    const _width = 1240.0;
    const _aspectRatio = _width / _height;
    final localizations = context.l10n;

    return AspectRatio(
      /// this size comes from law publication about job student card specs
      aspectRatio: _aspectRatio,
      child: SizedBox(
        height: _height,
        width: _width,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(
                'assets/image/certificate-42.png',
              ),
            ),
          ),
          child: AspectRatio(
            /// random size, copy from professional student card
            aspectRatio: _aspectRatio,
            child: SizedBox(
              height: _height,
              width: _width,
              child: CustomMultiChildLayout(
                delegate:
                    Ecole42LearningAchievementDelegate(position: Offset.zero),
                children: [
                  LayoutId(
                      id: 'studentIdentity',
                      child: Row(
                        children: [
                          ImageCardText(
                            text: '${model.givenName} ${model.familyName}, '
                                'born ${UIDate.displayDate(model.birthDate)}',
                            textStyle: Theme.of(context)
                                .textTheme
                                .ecole42LearningAchievementStudentIdentity,
                          ),
                        ],
                      )),
                  LayoutId(
                      id: 'level',
                      child: Row(
                        children: [
                          ImageCardText(
                            text: 'Level ${model.hasCredential.level}',
                            textStyle: Theme.of(context)
                                .textTheme
                                .ecole42LearningAchievementLevel,
                          ),
                        ],
                      )),
                  LayoutId(
                    id: 'signature',
                    child: imageUrl != ''
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              height:
                                  80 * MediaQuery.of(context).size.aspectRatio,
                              child:
                                  ImageFromNetwork(model.signatureLines.image),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
