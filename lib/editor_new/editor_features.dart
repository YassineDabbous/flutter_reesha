import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:richa/editor_new/controller.dart';
import 'package:richa/editor_new/editor_view.dart';
import 'package:richa/editor_new/resizable_widget.dart';
import 'package:richa/editor_new/view_object.dart';

mixin EditorFeatures on State<EditorView> {
  ImageEditorController controller = ImageEditorController();
  final List<ResizableWidget> widgets = [];
  BaseViewObject? backgroundView;
  bool isSingleMove = true;

  export() => widgets.map((e) => e.object.toJson()).toList();

  void addBGView(BaseViewObject? view) {
    backgroundView = view;
    if (mounted) {
      setState(() => backgroundView = view);
    }
  }

  void setSelectionMode(bool isSingleSelection) {
    isSingleMove = isSingleSelection;
    if (mounted) {
      setState(() => isSingleMove ? disableEditMode() : enableEditModel());
    }
  }

  void disableEditMode() {
    if (mounted) {
      setState(() {
        for (var element in widgets) {
          element.showRemoveIcon = false;
          element.canMove = false;
          element.borderColor = Colors.transparent;
          element.updateView();
        }
      });
    }
    //screenshotController.capture().then((value) => null);
  }

  void enableEditModel() {
    if (mounted) {
      setState(() {
        for (var element in widgets) {
          element.showRemoveIcon = true;
          element.canMove = true;
          element.borderColor = widget.borderColor;
          element.updateView();
        }
      });
    }
  }

  void updateView(int? position, BaseViewObject view) {
    assert(position == null || (position >= 0 && widgets.isNotEmpty && widgets.length - 1 <= position));
    position = position ?? widgets.length - 1;
    setState(() {
      debugPrint("viewUpdated");
      widgets[position!].object = view;
      widgets[position].updateView();
    });
  }

  void undo() {
    if (widgets.isNotEmpty) {
      try {
        setState(() {
          final lastUnVisibleView = widgets.lastWhere((element) => element.isVisible);
          lastUnVisibleView.isVisible = false;
          lastUnVisibleView.updateView();
        });
      } catch (_) {}
    }
  }

  void redo() {
    if (widgets.isNotEmpty) {
      try {
        setState(() {
          final lastUnVisibleView = widgets.firstWhere((element) => !element.isVisible);
          lastUnVisibleView.isVisible = true;
          lastUnVisibleView.updateView();
        });
      } catch (_) {}
    }
  }

  void flipView(int? position, bool isHorizontal) {
    assert(position == null || (position >= 0 && widgets.isNotEmpty && widgets.length - 1 <= position));
    position = position ?? widgets.length - 1;
    setState(() {
      final view = widgets[position!];
      var myTransform = Matrix4Transform.from(view.object.matrix4!);
      if (isHorizontal) {
        widgets[position].updateMatrix(myTransform.flipHorizontally().matrix4);
      } else {
        widgets[position].updateMatrix(myTransform.flipVertically().matrix4);
      }
    });
  }

  void updateMatrix(int? position, Matrix4 matrix) {
    assert(position == null || (position >= 0 && widgets.isNotEmpty && widgets.length - 1 <= position));
    position = position ?? widgets.length - 1;
    setState(() {
      widgets[position!].updateMatrix(matrix);
    });
  }

  void scale(int? position, double scale) {
    assert(position == null || (position >= 0 && widgets.isNotEmpty && widgets.length - 1 <= position));
    position = position ?? widgets.length - 1;
    setState(() {
      widgets[position!].setScale(scale);
    });
  }

  void zoomInOut(int? position, double value) {
    assert(position == null || (position >= 0 && widgets.isNotEmpty && widgets.length - 1 <= position));
    position = position ?? widgets.length - 1;
    setState(() {
      final view = widgets[position!];
      var myTransform = Matrix4Transform.from(view.object.matrix4!);
      widgets[position].updateMatrix(myTransform.scale(value).matrix4);
    });
  }

  void rotateView(int? position, double rotateDegree) {
    assert(position == null || (position >= 0 && widgets.isNotEmpty && widgets.length - 1 <= position));
    position = position ?? widgets.length - 1;
    setState(() {
      final view = widgets[position!];
      // widgets[position].updateMatrix(view.object.matrix4!..rotateX(pi / 2));
      final newDegree = (rotateDegree - (view.object.rotation ?? 0));
      print('old : ${view.object.rotation} rotateDegree : $rotateDegree ====> new degree : $newDegree');
      view.object.rotation = rotateDegree;
      var myTransform = Matrix4Transform.from(view.object.matrix4!);
      // widgets[position].updateMatrix(myTransform.rotateByCenterDegrees(rotateDegree, Size(view.getWidth(), view.getHeight())).matrix4);
      // print('${view.getWidth()} ------- ${view.getHeight()}');
      // print('${view.object.width} ------- ${view.object.height}');
      // widgets[position].updateMatrix(myTransform.rotate(rotateDegree, origin: Offset(view.object.width! / 2, view.object.height! / 2)).matrix4);
      widgets[position].updateMatrix(myTransform.rotateDegrees(newDegree, origin: Offset(view.object.width! / 4, view.object.height! / 4)).matrix4);
    });
  }

  void moveView(int? position, MoveType moveType, double value) {
    // print('position      =>    $position');
    // print('widgets.length     =>    ${widgets.length}');
    // print('widgets.length - 1 <= position    =>   ${widgets.length - 1 <= position}');
    assert(position == null || (position >= 0 && widgets.isNotEmpty && widgets.length - 1 <= position));
    position = position ?? widgets.length - 1;

    setState(() {
      final view = widgets[position!];
      var myTransform = Matrix4Transform.from(view.object.matrix4!);
      if (moveType == MoveType.right) {
        widgets[position].updateMatrix(myTransform.right(value).matrix4);
      } else if (moveType == MoveType.bottom) {
        widgets[position].updateMatrix(myTransform.down(value).matrix4);
      } else if (moveType == MoveType.top) {
        widgets[position].updateMatrix(myTransform.up(value).matrix4);
      } else if (moveType == MoveType.left) {
        widgets[position].updateMatrix(myTransform.left(value).matrix4);
      }
    });
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
  //
  //
  //
  //
  //
  //
  //
  //
  //

  void addView({required BaseViewObject view, Matrix4? matrix4}) {
    _addViewInList(view, matrix4: matrix4);
    if (mounted) {
      setState(() {});
    }
  }

  void _addViewInList(BaseViewObject view, {Matrix4? matrix4}) {
    // unfocus last view item
    if (widgets.isNotEmpty) {
      final lastViewItem = widgets.last;
      lastViewItem.showRemoveIcon = false;
      lastViewItem.borderColor = Colors.transparent;
      lastViewItem.canMove = false;
      lastViewItem.updateView();
    }

    // make new resizable item
    final resizableView = ResizableWidget(
      key: ObjectKey(DateTime.now().toString()),
      canMove: true,
      borderColor: widget.borderColor,
      removeIcon: widget.removeIcon,
      onRemove: _onItemRemove,
      onClick: _onItemClick,
      onTouchStart: _onItemTouchStart,
      onTouchEnd: _onItemTouchEnd,
      object: (view..index = widgets.length),
    );

    widgets.add(resizableView);
  }

  void _onItemRemove(key, index) {
    debugPrint("_onItemRemove index $index");
    // final removeView = widgets.firstWhere((element) => element.key == key);
    // removeView.isVisible = false;
    // removeView.updateView();
    final finalIndex = widgets.indexWhere((element) => element.key == key);
    widgets.removeAt(finalIndex);
    for (var i = 0; i < widgets.length; i++) {
      widgets[i].object.index = i;
    }
    setState(() {});
  }

  void _onItemClick(key, index) {
    debugPrint("_onItemClick index $index");
    final finalIndex = widgets.indexWhere((element) => element.key == key);
    if (widget.clickToFocusAndMove) {
      focus(finalIndex);
    } else {
      final touchView = widgets[finalIndex];
      widget.onClick?.call(widgets.length - 1, touchView.object);
    }
  }

  _onItemTouchStart(key, index) {
    debugPrint("_onItemTouchStart index $index");
    if (!widget.clickToFocusAndMove) {
      final finalIndex = widgets.indexWhere((element) => element.key == key);
      focus(finalIndex);
    }
  }

  _onItemTouchEnd(key, index, matrix) {
    debugPrint("_onItemTouchEnd index $index");
    if (widget.onMoved != null) {
      final touchView = widgets.firstWhere((element) => element.key == key);
      widget.onMoved!(index, touchView.object, matrix);
    }
  }

  focus(int finalIndex) {
    final touchView = widgets.removeAt(finalIndex);

    if (isSingleMove) {
      for (var element in widgets) {
        if (element.key != touchView.key) {
          element.unfocus();
        }
      }
    }

    touchView.focus(borderColor: widget.borderColor);
    widgets.add(touchView);
    widget.onClick?.call(widgets.length - 1, touchView.object);
    setState(() {});
  }
}
