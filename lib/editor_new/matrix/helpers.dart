import 'package:flutter/widgets.dart';

typedef MatrixGestureDetectorCallback = void Function(
  Offset focalPoint,
  Matrix4 matrix,
  Matrix4 translationDeltaMatrix,
  Matrix4 scaleDeltaMatrix,
  Matrix4 rotationDeltaMatrix,
);

class ValueUpdater<T> {
  final T Function(T oldValue, T newValue) onUpdate;
  T value;

  ValueUpdater({
    required this.value,
    required this.onUpdate,
  });

  T update(T newValue) {
    T updated = onUpdate(value, newValue);
    value = newValue;
    return updated;
  }
}

class MatrixDecomposedValues {
  /// Translation, in most cases useful only for matrices that are nothing but
  /// a translation (no scale and no rotation).
  final Offset translation;

  /// Scaling factor.
  final double scale;

  /// Rotation in radians, (-pi..pi) range.
  final double rotation;

  MatrixDecomposedValues(this.translation, this.scale, this.rotation);

  @override
  String toString() {
    return 'MatrixDecomposedValues(translation: $translation, scale: ${scale.toStringAsFixed(3)}, rotation: ${rotation.toStringAsFixed(3)})';
  }
}
