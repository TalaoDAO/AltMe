import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class ProfessionalStudentCardDetailsWidget extends StatelessWidget {
  const ProfessionalStudentCardDetailsWidget({Key? key, required this.model})
      : super(key: key);
  final ProfessionalStudentCardModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          /// this size comes from law publication about job student card specs
          aspectRatio: 508.67 / 319.67,
          child: SizedBox(
            height: 319.67,
            width: 508.67,
            child: CardAnimationWidget(
              recto: JobStudentCardRecto(
                  recipient: model.recipient, expires: model.expires),
              verso: const JobStudentCardVerso(),
            ),
          ),
        ),
      ],
    );
  }
}
