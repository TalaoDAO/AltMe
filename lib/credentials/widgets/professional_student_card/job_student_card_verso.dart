import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class JobStudentCardVerso extends Verso {
  const JobStudentCardVerso({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/image/adecco_student_card_verso.png',
          ),
        ),
      ),
      child: const AspectRatio(
        /// this size comes from law publication about job student card specs
        aspectRatio: 508.67 / 319.67,
        child: SizedBox(
          height: 319.67,
          width: 508.67,
        ),
      ),
    );
  }
}
