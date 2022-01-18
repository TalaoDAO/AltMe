import 'package:flutter/widgets.dart';
import 'package:ssi_crypto_wallet/home/view/tab_bar/clip_shadow.dart';
import 'package:ssi_crypto_wallet/home/view/tab_bar/clip_shadow.dart' show ClipShadow;
import 'package:ssi_crypto_wallet/home/view/tab_bar/edge.dart';
import 'package:ssi_crypto_wallet/home/view/tab_bar/parallelogram_clipper.dart';

class Parallelogram extends StatelessWidget {
  const Parallelogram(
      {Key? key,
      required this.cutLength,
      required this.child,
      this.edge = Edge.right,
      this.clipShadows = const [],})
      : super(key: key);

  final Widget child;
  final double cutLength;
  final Edge edge;

  ///List of shadows to be cast on the border
  final List<ClipShadow> clipShadows;

  @override
  Widget build(BuildContext context) {
    var clipper = ParallelogramClipper(cutLength, edge);
    return CustomPaint(
      painter: ClipShadowPainter(clipper, clipShadows),
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}
