import 'package:flutter/material.dart';
import 'package:richa/editor_new/view_object.dart';
import 'matrix/matrix_gesture_detector.dart';
import 'dart:async';
import 'dart:math' as math;

// ignore: must_be_immutable
class ResizableWidget extends StatefulWidget {
  ResizableWidget({
    key,
    required this.object,
    this.canMove = true,
    this.showRemoveIcon = true,
    this.borderColor = Colors.black,
    this.isVisible = true,
    this.removeIcon,
    required this.onRemove,
    required this.onTouchStart,
    required this.onClick,
    required this.onTouchEnd,
  }) : super(key: key);

  BaseViewObject object;
  bool canMove;
  bool showRemoveIcon;
  Color borderColor;
  bool isVisible;
  final Icon? removeIcon;

  /// return widget key and his index
  final Function(Key, int) onRemove;

  /// return widget key, index and his type if you added
  final Function(Key, int) onTouchStart;

  /// return widget key, index and his type if you added
  final Function(Key, int) onClick;

  /// return widget key, index and his matrix
  final Function(Key, int, Matrix4) onTouchEnd;

  final resizableWidgetState = _ResizableWidgetState();

  @override
  // ignore: no_logic_in_create_state
  State<ResizableWidget> createState() => resizableWidgetState;

  void updateMatrix(Matrix4 matrix4) => resizableWidgetState._setMatrix(matrix4);
  void setScale(double scl) {
    object.scale = scl;
    resizableWidgetState.refresh();
  }

  void updateView() {
    // print((object as TextViewObject).text);
    resizableWidgetState.refresh();
    // ignore: invalid_use_of_protected_member
    // resizableWidgetState.setState(() {});
  }

  void focus({Color? borderColor}) {
    showRemoveIcon = true;
    canMove = true;
    this.borderColor = borderColor ?? Colors.red;
    updateView();
  }

  void unfocus() {
    showRemoveIcon = false;
    canMove = false;
    borderColor = Colors.transparent;
    updateView();
  }

  double getX() => resizableWidgetState._getX();

  double getY() => resizableWidgetState._getY();

  double getAngle() => resizableWidgetState._getAngle();

  double getHeight() => resizableWidgetState._getHeight();

  double getWidth() => resizableWidgetState._getWidth();
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

class _ResizableWidgetState extends State<ResizableWidget> {
  GlobalKey key = GlobalKey();
  Widget? viewWidget;

  Matrix4 matrix = Matrix4.identity();
  bool _isTouched = false;
  Timer? _timer;
  RenderBox get box => key.currentContext?.findRenderObject() as RenderBox;
  Offset get offset => box.localToGlobal(Offset.zero);

  double _getX() => offset.dx;
  double _getY() => offset.dy - 87.6;
  double _getWidth() => box.size.width;
  double _getHeight() => box.size.height;
  double _getAngle() => -math.atan2(offset.dy - 87.6, offset.dx);

  @override
  void initState() {
    super.initState();
    if (widget.object.matrix4 != null) {
      setState(() => matrix = widget.object.matrix4!);
    } else {
      widget.object.matrix4 = matrix;
    }
    setWidget();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  setWidget() {
    if (widget.object is ImageViewObject) {
      viewWidget = Image.file((widget.object as ImageViewObject).file);
    }
    if (widget.object is TextViewObject) {
      final o = (widget.object as TextViewObject);
      viewWidget = Text(
        o.text,
        style: o.style.styleFlutter,
      );
    }
  }

  void _setMatrix(Matrix4 matrix4) {
    widget.object.matrix4 = matrix4;
    matrix = matrix4;
    if (mounted) {
      setState(() {});
    }
  }

  refresh() {
    if (mounted) {
      setWidget();
      setState(() {});
    }
  }

  onTapped() {
    widget.onClick(widget.key!, widget.object.index);
    widget.onTouchStart(widget.key!, widget.object.index);
  }

  onMatrixUpdate(Offset position, Matrix4 m, Matrix4 translationDeltaMatrix, Matrix4 scaleDeltaMatrix, Matrix4 rotationDeltaMatrix) {
    if (widget.canMove) {
      matrix = m;
      widget.object.matrix4 = m;
    }
    if (!_isTouched) {
      _isTouched = true;
      widget.onTouchStart(widget.key!, widget.object.index);
    }
    setState(() {});

    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      _timer = null;
    }

    _timer = Timer(const Duration(milliseconds: 500), () {
      // 'main: onMoved => postion:$position,      type: ${object.runtimeType},      ==> x: ${matrix.getTranslation()[0]},
      widget.object.left = m.getTranslation()[0].toInt();
      widget.object.top = m.getTranslation()[1].toInt();
      widget.onTouchEnd(widget.key!, widget.object.index, m);
      if (mounted) {
        setState(() => _isTouched = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (!widget.isVisible)
        ? const SizedBox()
        : Transform(
            transform: widget.object.scale == null ? matrix : matrix * widget.object.scale,
            child: Stack(
              key: key,
              children: [
                MatrixGestureDetector(
                  onMatrixUpdate: onMatrixUpdate,
                  focalPointAlignment: Alignment.center,
                  matrix4Old: matrix,
                  child: InkWell(
                    onTap: onTapped,
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: widget.borderColor), borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                      child: viewWidget,
                      // padding: const EdgeInsets.all(10.0),
                    ),
                  ),
                ),
                if (widget.showRemoveIcon)
                  Positioned(
                    child: InkWell(
                      onTap: () => widget.onRemove(widget.key!, widget.object.index),
                      child: widget.removeIcon ?? Icon(Icons.close, size: 20.0 * (1 / (widget.object.scale ?? 1))),
                    ),
                  ),
              ],
            ),
          );
  }
}
