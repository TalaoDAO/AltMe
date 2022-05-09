import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class JobStudentCardRecto extends Recto {
  const JobStudentCardRecto({
    Key? key,
    required this.recipient,
    required this.expires,
  }) : super(key: key);

  final ProfessionalStudentCardRecipientModel recipient;
  final String expires;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/image/adecco_student_card_recto.png',
          ),
        ),
      ),
      child: AspectRatio(
        /// this size comes from law publication about job student card specs
        aspectRatio: 508.67 / 319.67,
        child: SizedBox(
          height: 319.67,
          width: 508.67,
          child: CustomMultiChildLayout(
            delegate: ProfessionalStudentCardDelegate(position: Offset.zero),
            children: [
              LayoutId(
                  id: 'familyName',
                  child: ImageCardText(text: recipient.familyName)),
              LayoutId(
                id: 'givenName',
                child: ImageCardText(text: recipient.givenName),
              ),
              LayoutId(
                id: 'birthDate',
                child: ImageCardText(
                    text: UIDate.displayDate(recipient.birthDate)),
              ),
              LayoutId(
                id: 'expires',
                child: ImageCardText(text: UIDate.displayDate(expires)),
              ),
              LayoutId(
                id: 'signature',
                child: const ImageCardText(text: 'missing field'),
              ),
              LayoutId(
                id: 'image',
                child: ImageFromNetwork(recipient.image),
              )
            ],
          ),
        ),
      ),
    );
  }
}
