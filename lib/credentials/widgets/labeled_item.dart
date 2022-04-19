import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledItem extends StatelessWidget {
  const LabeledItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.hero,
    required this.value,
  }) : super(key: key);

  final String icon;
  final String label;
  final String hero;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 16,
            height: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TooltipText(
              tag: hero,
              text: value,
              tooltip: '$label $value',
              style: GoogleFonts.poppins(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
}
