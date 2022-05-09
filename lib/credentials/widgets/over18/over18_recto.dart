import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class Over18Recto extends Recto {
  const Over18Recto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/image/over18_recto.png',
          ),
        ),
      ),
      child: const AspectRatio(
        /// size from over18 recto picture
        //TODO remove hadcoded size
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
        ),
      ),
    );
  }
}
