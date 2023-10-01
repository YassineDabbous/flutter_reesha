import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:richa/editor_new/view_object.dart';

enum MoveType {
  left,
  right,
  top,
  bottom,
}

class ImageEditorController {
  ///
  Function()? clear;
  List<BaseViewObject> Function()? export;
  List<Map<String, dynamic>> Function()? exportAsJson;
  
  BaseViewObject Function(int? position)? getModel;

  /// This function user for add view in editor
  Function({required BaseViewObject view, Matrix4? matrix4})? addView;

  /// update view of given position.
  Function(int? position, BaseViewObject view)? updateView;

  /// hide Border and Remove button from all views
  Function()? hideViewControl;

  /// show Border and Remove button in all views
  Function()? showViewControl;

  /// allow editor to move, zoom and rotate multiple views. if you set true than only one view can move, zoom and rotate default value is true.
  Function(bool isMultipleSelection)? canEditMultipleView;

  /// set editor background view it will overlap background color.
  Function(BaseViewObject? view)? addBackgroundView;

  // /// set editor background color.
  // Function(Color color)? addBackgroundColor;

  /// redo your changes
  Function()? redo;

  /// undo your changes
  Function()? undo;

  /// move view by provide position and move type like left, right and his his value.
  /// Ex. position = 0, moveType = MoveType.left, value = 10
  Function(int? position, MoveType moveType, double value)? moveView;

  /// rotate particular view
  Function(int? position, double rotateDegree)? rotateView;

  /// zoom In and Out view
  /// for zoom view value > 1
  /// for zoom out view value < 0 like (0.1)
  Function(int? position, double value)? zoomInOutView;

  /// update matrix of particular view
  Function(int? position, Matrix4 matrix4)? updateMatrix;

  Function(int? position, double scale)? scale;

  /// flip particular view
  Function(int? position, bool isHorizontal)? flipView;

  /// save all edited views and his position and return Uint8List data.
  Future<Uint8List?> Function()? saveEditing;
}
