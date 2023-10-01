import 'package:flutter/widgets.dart';
import 'dart:math';

import 'package:richa/editor_new/matrix/helpers.dart';

/// [MatrixGestureDetector] detects translation, scale and rotation gestures
/// and combines them into [Matrix4] object that can be used by [Transform] widget
/// or by low level [CustomPainter] code. You can customize types of reported
/// gestures by passing [shouldTranslate], [shouldScale] and [shouldRotate]
/// parameters.
// ignore: must_be_immutable
class MatrixGestureDetector extends StatefulWidget {
  final MatrixGestureDetectorCallback onMatrixUpdate;

  /// {@macro flutter.widgets.child}
  final Widget child;
  final bool clipChild;

  final bool detectTranslate;
  final bool detectScale;
  final bool detectRotate;

  /// When set, it will be used for computing a "fixed" focal point
  /// aligned relative to the size of this widget.
  final Alignment? focalPointAlignment;

  Matrix4? matrix4Old;

  MatrixGestureDetector({
    Key? key,
    required this.child,
    this.matrix4Old,
    required this.onMatrixUpdate,
    this.detectTranslate = true,
    this.detectScale = true,
    this.detectRotate = true,
    this.clipChild = true,
    this.focalPointAlignment,
  }) : super(key: key);

  @override
  State<MatrixGestureDetector> createState() => _MatrixGestureDetectorState();
}

//
//
//
//
//
//
class _MatrixGestureDetectorState extends State<MatrixGestureDetector> {
  Matrix4 translationDeltaMatrix = Matrix4.identity();
  Matrix4 scaleDeltaMatrix = Matrix4.identity();
  Matrix4 rotationDeltaMatrix = Matrix4.identity();
  Matrix4 matrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      child: widget.clipChild ? ClipRect(child: widget.child) : widget.child,
    );
  }

  ValueUpdater<Offset> translationUpdater = ValueUpdater(
    value: Offset.zero,
    onUpdate: (oldVal, newVal) => newVal - oldVal,
  );
  ValueUpdater<double> scaleUpdater = ValueUpdater(
    value: 1.0,
    onUpdate: (oldVal, newVal) => newVal / oldVal,
  );
  ValueUpdater<double> rotationUpdater = ValueUpdater(
    value: 0.0,
    onUpdate: (oldVal, newVal) => newVal - oldVal,
  );

  void onScaleStart(ScaleStartDetails details) {
    translationUpdater.value = details.focalPoint;
    scaleUpdater.value = 1.0;
    rotationUpdater.value = 0.0;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    translationDeltaMatrix = Matrix4.identity();
    scaleDeltaMatrix = Matrix4.identity();
    rotationDeltaMatrix = Matrix4.identity();

    if (widget.matrix4Old != null) {
      matrix = widget.matrix4Old!;
      widget.matrix4Old = null;
    }

    // handle matrix translating
    if (widget.detectTranslate) {
      Offset translationDelta = translationUpdater.update(details.focalPoint);
      translationDeltaMatrix = _translate(translationDelta);
      matrix = translationDeltaMatrix * matrix;
    }

    final focalPointAlignment = widget.focalPointAlignment;
    final focalPoint = focalPointAlignment == null ? details.localFocalPoint : focalPointAlignment.alongSize(context.size!);

    // handle matrix scaling
    if (widget.detectScale && details.scale != 1.0) {
      double scaleDelta = scaleUpdater.update(details.scale);
      scaleDeltaMatrix = _scale(scaleDelta, focalPoint);
      matrix = scaleDeltaMatrix * matrix;
    }

    // handle matrix rotating
    if (widget.detectRotate && details.rotation != 0.0) {
      double rotationDelta = rotationUpdater.update(details.rotation);
      rotationDeltaMatrix = _rotate(rotationDelta, focalPoint);
      matrix = rotationDeltaMatrix * matrix;
    }

    widget.onMatrixUpdate(details.focalPoint, matrix, translationDeltaMatrix, scaleDeltaMatrix, rotationDeltaMatrix);
  }

  Matrix4 _translate(Offset translation) {
    var dx = translation.dx;
    var dy = translation.dy;

    //  ..[0]  = 1       # x scale
    //  ..[5]  = 1       # y scale
    //  ..[10] = 1       # diagonal "one"
    //  ..[12] = dx      # x translation
    //  ..[13] = dy      # y translation
    //  ..[15] = 1       # diagonal "one"
    return Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
  }

  Matrix4 _scale(double scale, Offset focalPoint) {
    var dx = (1 - scale) * focalPoint.dx;
    var dy = (1 - scale) * focalPoint.dy;

    //  ..[0]  = scale   # x scale
    //  ..[5]  = scale   # y scale
    //  ..[10] = 1       # diagonal "one"
    //  ..[12] = dx      # x translation
    //  ..[13] = dy      # y translation
    //  ..[15] = 1       # diagonal "one"
    return Matrix4(scale, 0, 0, 0, 0, scale, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
  }

  Matrix4 _rotate(double angle, Offset focalPoint) {
    var c = cos(angle);
    var s = sin(angle);
    var dx = (1 - c) * focalPoint.dx + s * focalPoint.dy;
    var dy = (1 - c) * focalPoint.dy - s * focalPoint.dx;

    //  ..[0]  = c       # x scale
    //  ..[1]  = s       # y skew
    //  ..[4]  = -s      # x skew
    //  ..[5]  = c       # y scale
    //  ..[10] = 1       # diagonal "one"
    //  ..[12] = dx      # x translation
    //  ..[13] = dy      # y translation
    //  ..[15] = 1       # diagonal "one"
    return Matrix4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
  }
}
