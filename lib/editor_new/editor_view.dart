import 'package:flutter/material.dart';
import 'package:richa/editor_new/controller.dart';
import 'package:richa/editor_new/editor_features.dart';
import 'package:richa/editor_new/view_object.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

class EditorView extends StatefulWidget {
  const EditorView({
    key,
    required this.onInitialize,
    this.onViewTouch,
    this.onMoved,
    this.onClick,
    this.clickToFocusAndMove = false,
    this.borderColor = Colors.black,
    this.removeIcon,
  }) : super(key: key);

  @override
  EditorViewState createState() => EditorViewState();

  final Function(ImageEditorController) onInitialize;

  /// this event fire every time you touch view.
  final Function(int, BaseViewObject)? onViewTouch;

  /// this event fire every time when user remove touch from view.
  final Function(int, BaseViewObject, Matrix4)? onMoved;

  /// this event fire every time when user click view.
  final Function(int, BaseViewObject)? onClick;

  /// set border color of widget
  final Color borderColor;

  /// set remove icon
  final Icon? removeIcon;

  final bool clickToFocusAndMove;
}

class EditorViewState extends State<EditorView> with EditorFeatures {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<Uint8List?> _saveView() async {
    disableEditMode();
    return await _screenshotController.capture();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeController();
    });

    if (widget.clickToFocusAndMove) {
      setSelectionMode(true);
    }
  }

  initializeController() {
    controller.getModel = (int? index) => index != null ? widgets.elementAt(index).object : widgets.last.object;
    controller.clear = () => setState(() => widgets.clear());
    controller.export = () => widgets.map((e) => e.object).toList();
    controller.exportAsJson = () => widgets.map((e) => e.object.toJson()).toList();
    controller.saveEditing = () => _saveView();
    controller.addBackgroundView = addBGView;
    controller.addView = addView;
    controller.moveView = moveView;
    controller.canEditMultipleView = (isMultipleSelection) => setSelectionMode(!isMultipleSelection);
    controller.flipView = flipView;
    controller.rotateView = rotateView;
    controller.hideViewControl = disableEditMode;
    controller.showViewControl = enableEditModel;
    controller.redo = redo;
    controller.undo = undo;
    controller.updateMatrix = updateMatrix;
    controller.scale = scale;
    controller.updateView = updateView;
    controller.zoomInOutView = zoomInOut;
    // controller.init(this);
    widget.onInitialize(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: (backgroundView?.backgroundColor != null) ? Color(backgroundView!.backgroundColor!) : Colors.white,
        child: ClipRect(
          child: Stack(
            children: [
              if (backgroundView != null && backgroundView is ImageViewObject)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.file(
                    (backgroundView as ImageViewObject).file,
                    height: backgroundView?.height,
                    width: backgroundView?.width,
                    fit: BoxFit.fill,
                  ),
                ),
              ...widgets,
            ],
          ),
        ),
      ),
    );
  }
}
