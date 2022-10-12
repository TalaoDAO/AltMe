import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BaseBoxDecoration extends Decoration {
  const BaseBoxDecoration({
    this.color,
    this.shapeColor = Colors.white10,
    this.shapeSize = 128.0,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.value = 0.0,
    this.anchors = const [],
  });

  BaseBoxDecoration copyWith({
    Color? color,
    Color? shapeColor,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
  }) {
    return BaseBoxDecoration(
      color: color ?? this.color,
      shapeColor: shapeColor ?? this.shapeColor,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      gradient: gradient ?? this.gradient,
    );
  }

  final Color? color;
  final Color? shapeColor;
  final double? shapeSize;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  final double value;

  final List<Alignment> anchors;

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    if (borderRadius != null) {
      return Path()
        ..addRRect(borderRadius!.resolve(textDirection).toRRect(rect));
    }
    return Path()..addRect(rect);
  }

  BaseBoxDecoration scale(double factor) {
    return BaseBoxDecoration(
      color: Color.lerp(null, color, factor),
      shapeColor: Color.lerp(null, shapeColor, factor),
      borderRadius: BorderRadiusGeometry.lerp(null, borderRadius, factor),
      boxShadow: BoxShadow.lerpList(null, boxShadow, factor),
      gradient: gradient?.scale(factor),
    );
  }

  @override
  bool get isComplex => boxShadow != null;

  @override
  BaseBoxDecoration? lerpFrom(Decoration? a, double t) {
    if (a == null) return scale(t);
    if (a is BaseBoxDecoration) return BaseBoxDecoration.lerp(a, this, t);
    return super.lerpFrom(a, t) as BaseBoxDecoration?;
  }

  @override
  BaseBoxDecoration? lerpTo(Decoration? b, double t) {
    if (b == null) return scale(1.0 - t);
    if (b is BaseBoxDecoration) return BaseBoxDecoration.lerp(this, b, t);
    return super.lerpTo(b, t) as BaseBoxDecoration?;
  }

  static BaseBoxDecoration? lerp(
    BaseBoxDecoration? a,
    BaseBoxDecoration? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    if (a == null) return b!.scale(t);
    if (b == null) return a.scale(1.0 - t);
    if (t == 0.0) return a;
    if (t == 1.0) return b;
    return BaseBoxDecoration(
      color: Color.lerp(a.color, b.color, t),
      shapeColor: Color.lerp(a.shapeColor, b.shapeColor, t),
      borderRadius:
          BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is BaseBoxDecoration &&
        other.color == color &&
        other.shapeColor == shapeColor &&
        other.borderRadius == borderRadius &&
        listEquals<BoxShadow>(other.boxShadow, boxShadow) &&
        other.gradient == gradient;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      shapeColor,
      borderRadius,
      Object.hashAll(boxShadow!),
      gradient,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.whitespace
      ..emptyBodyDescription = '<no decorations specified>';

    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(ColorProperty('shapeColor', shapeColor, defaultValue: null));
    properties.add(
      DiagnosticsProperty<BorderRadiusGeometry>(
        'borderRadius',
        borderRadius,
        defaultValue: null,
      ),
    );
    properties.add(
      IterableProperty<BoxShadow>(
        'boxShadow',
        boxShadow,
        defaultValue: null,
        style: DiagnosticsTreeStyle.whitespace,
      ),
    );
    properties.add(
      DiagnosticsProperty<Gradient>(
        'gradient',
        gradient,
        defaultValue: null,
      ),
    );
  }

  @override
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) {
    assert(
      (Offset.zero & size).contains(position),
      'size must contain position!',
    );
    if (borderRadius != null) {
      final bounds =
          borderRadius!.resolve(textDirection).toRRect(Offset.zero & size);
      return bounds.contains(position);
    }
    return true;
  }

  @override
  _BaseBoxDecorationPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BaseBoxDecorationPainter(this, onChanged);
  }
}

class _BaseBoxDecorationPainter extends BoxPainter {
  _BaseBoxDecorationPainter(this._decoration, VoidCallback? onChanged)
      : super(onChanged);

  final BaseBoxDecoration _decoration;

  Paint? _cachedBackgroundPaint;
  Rect? _rectForCachedBackgroundPaint;

  Paint? _getBackgroundPaint(Rect rect, TextDirection textDirection) {
    assert(
      _decoration.gradient != null || _rectForCachedBackgroundPaint == null,
      '_decoration.gradient != null || _rectForCachedBackgroundPaint == null',
    );

    if (_cachedBackgroundPaint == null ||
        (_decoration.gradient != null &&
            _rectForCachedBackgroundPaint != rect)) {
      final paint = Paint();
      if (_decoration.color != null) {
        paint.color = _decoration.color!;
      }
      if (_decoration.gradient != null) {
        paint.shader = _decoration.gradient!.createShader(
          rect,
          textDirection: textDirection,
        );
        _rectForCachedBackgroundPaint = rect;
      }
      _cachedBackgroundPaint = paint;
    }

    return _cachedBackgroundPaint;
  }

  void _paintBox(
    Canvas canvas,
    Rect rect,
    Paint paint,
    TextDirection textDirection,
  ) {
    if (_decoration.borderRadius == null) {
      canvas.drawRect(rect, paint);
    } else {
      canvas.drawRRect(
        _decoration.borderRadius!.resolve(textDirection).toRRect(rect),
        paint,
      );
    }
  }

  void _paintShadows(
    Canvas canvas,
    Rect rect,
    TextDirection textDirection,
  ) {
    if (_decoration.boxShadow == null) return;
    for (final boxShadow in _decoration.boxShadow!) {
      final paint = boxShadow.toPaint();
      final bounds =
          rect.shift(boxShadow.offset).inflate(boxShadow.spreadRadius);
      _paintBox(canvas, bounds, paint, textDirection);
    }
  }

  void _paintBackgroundColor(
    Canvas canvas,
    Rect rect,
    TextDirection textDirection,
  ) {
    if (_decoration.color != null || _decoration.gradient != null) {
      _paintBox(
        canvas,
        rect,
        _getBackgroundPaint(rect, textDirection)!,
        textDirection,
      );
    }
  }

  void _paintTriangles(
    Canvas canvas,
    Rect rect,
    TextDirection textDirection,
  ) {
    final trianglePaint = Paint();
    trianglePaint.color = _decoration.shapeColor!;

    final length = (_decoration.shapeSize! * 1.73205) / 2.0;

    final triangle = Path();
    triangle.moveTo(0, length);

    const r120 = (120.0 * 3.14159) / 180.0;
    final bx = -(length * sin(r120));
    final by = length * cos(r120);
    triangle.lineTo(bx, by);

    const r240 = (240.0 * 3.14159) / 180.0;
    final ax = -(length * sin(r240));
    final ay = length * cos(r240);
    triangle.lineTo(ax, ay);

    triangle.close();

    canvas.save();

    if (_decoration.borderRadius == null) {
      canvas.clipRect(rect);
    } else {
      canvas.clipRRect(
        _decoration.borderRadius!.resolve(textDirection).toRRect(rect),
      );
    }

    final animRad = (_decoration.value * 3.14159) / 180.0;
    final transform = Matrix4.rotationZ(animRad);

    final triangleA = triangle
        .shift(Offset(-length * 0.15, -length * 0.15))
        .transform(transform.storage);

    final triangleB = triangle
        .shift(Offset(length * 0.15, length * 0.15))
        .transform(transform.storage);

    for (final alignment in _decoration.anchors) {
      final shift = alignment.withinRect(rect);

      canvas.drawPath(triangleA.shift(shift), trianglePaint);
      canvas.drawPath(triangleB.shift(shift), trianglePaint);
    }

    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null, 'configuration size must not be null');
    final rect = offset & configuration.size!;
    final textDirection = configuration.textDirection;
    _paintShadows(canvas, rect, textDirection!);
    _paintBackgroundColor(canvas, rect, textDirection);
    _paintTriangles(canvas, rect, textDirection);
  }

  @override
  String toString() {
    return 'BaseBoxPainter for $_decoration';
  }
}
