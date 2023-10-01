// import 'package:flutter/widgets.dart';
// import 'package:richa/editor_new/matrix/helpers.dart';

// ///
// /// Compose the matrix from translation, scale and rotation matrices - you can
// /// pass a null to skip any matrix from composition.
// ///
// /// If [matrix] is not null the result of the composing will be concatenated
// /// to that [matrix], otherwise the identity matrix will be used.
// ///
// Matrix4 compose(Matrix4? matrix, Matrix4? translationMatrix, Matrix4? scaleMatrix, Matrix4? rotationMatrix) {
//   matrix ??= Matrix4.identity();
//   if (translationMatrix != null) matrix = translationMatrix * matrix;
//   if (scaleMatrix != null) matrix = scaleMatrix * matrix;
//   if (rotationMatrix != null) matrix = rotationMatrix * matrix;
//   return matrix!;
// }

// ///
// /// Decomposes [matrix] into [MatrixDecomposedValues.translation],
// /// [MatrixDecomposedValues.scale] and [MatrixDecomposedValues.rotation] components.
// ///
// MatrixDecomposedValues decomposeToValues(Matrix4 matrix) {
//   var array = matrix.applyToVector3Array([0, 0, 0, 1, 0, 0]);
//   Offset translation = Offset(array[0], array[1]);
//   Offset delta = Offset(array[3] - array[0], array[4] - array[1]);
//   double scale = delta.distance;
//   double rotation = delta.direction;
//   return MatrixDecomposedValues(translation, scale, rotation);
// }
