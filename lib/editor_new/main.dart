import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:richa/editor_new/controller.dart';
import 'package:richa/editor_new/editor_view.dart';
import 'package:richa/editor_new/view_object.dart';
import 'package:richa/helpers/dialogs.dart';
import 'package:richa/helpers/local_storage.dart';
import 'package:richa/my_picker.dart';
import '../result.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ImageEditorController _editorCtrl;
  int? width = 1200;
  int? height = 600;
  SharedPrefHelper store = SharedPrefHelper();

  onInitialize(ImageEditorController controller) {
    setState(() => _editorCtrl = controller);
  }

  preview() async {
    final value = await _editorCtrl.saveEditing?.call();
    if (value != null) {
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Result(uint8list: value)));
      }
    }
  }

  saveAsImage() async {
    final value = await _editorCtrl.saveEditing?.call();
    if (value != null) {
      final path = await pickPathToSave();
      print('save to $path');
      if (path != null) {
        await saveFile(data: value, to: path);
        print('saved to $path');
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error on choosing folder')));
      }
    }
  }

  saveProject() async {
    final value = _editorCtrl.export?.call();
    store.saveTemplate(Template(name: 'xxx', objects: value!));
  }

  importProject() async {
    Template? template = await store.getTemplate();
    for (var element in template!.objects) {
      _editorCtrl.addView?.call(view: element);
    }
  }

  final List<Color> _colorArray = [
    Colors.red,
    Colors.black,
    Colors.white,
    Colors.amber,
    Colors.black38,
    Colors.yellow,
    Colors.orange,
    Colors.deepOrange,
    Colors.pink,
    Colors.blue,
    Colors.cyan,
    Colors.deepPurple,
    Colors.teal,
  ];

  // useTemplate() {
  //   pickOneFilePath(
  //     onPick: (image) {
  //       if (image != null) {
  //         final sz = MediaQuery.of(context).size;
  //         final x = sz.width - (200 + 2);
  //         final y = sz.height - (200 + 2); // kBottomNavigationBarHeight + kToolbarHeight
  //         // print('screen ====> $sz         position  ====>  $x, $y');
  //         _editorCtrl.addView?.call(
  //           // view: ImageViewObject(raw: image.toList()),
  //           view: ImageViewObject(path: image),
  //           matrix4: Matrix4.identity()..translate(x, y),
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          //
          //
          //
          //
          //
          Center(
            child: SizedBox(
              width: width?.toDouble(),
              height: height?.toDouble(),
              child: EditorView(
                borderColor: Colors.red,
                clickToFocusAndMove: true,
                onInitialize: onInitialize,
                // onMoved: (position, object, matrix) => print(
                //   'main: onMoved => postion:$position,      type: ${object.runtimeType},      ==> x: ${matrix.getTranslation()[0]},      y: ${matrix.getTranslation()[1]}',
                // ),
                onClick: (position, object) {
                  // debugPrint("onViewClick");
                  if (object is TextViewObject) {
                    _addText(position, object);
                  }
                },
              ),
            ),
          ),
          //
          //
          //
          //
          //
          SizedBox(
            height: kToolbarHeight,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.2,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: showMenu, icon: const FaIcon(FontAwesomeIcons.ellipsisVertical)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 60,
                    child: ListView(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        IconButton(onPressed: _scale, icon: const FaIcon(FontAwesomeIcons.minimize)),
                        IconButton(onPressed: _rotate, icon: const FaIcon(FontAwesomeIcons.arrowsSpin)),
                        IconButton(onPressed: () => _editorCtrl.zoomInOutView?.call(null, 0.5), icon: const Icon(Icons.zoom_out)),
                        IconButton(onPressed: () => _editorCtrl.zoomInOutView?.call(null, 2.0), icon: const Icon(Icons.zoom_in)),
                        IconButton(
                            onPressed: () => _editorCtrl.moveView?.call(null, MoveType.bottom, 50), icon: const FaIcon(FontAwesomeIcons.upDownLeftRight)),
                        IconButton(onPressed: () => _editorCtrl.flipView?.call(null, false), icon: const Icon(Icons.flip)),
                        // IconButton(onPressed: () => _editorCtrl.rotateView?.call(null, 90), icon: const Icon(Icons.rotate_left)),
                        // IconButton(onPressed: () => _editorCtrl.canEditMultipleView?.call(false), icon: const Icon(Icons.photo_size_select_large)),
                        // IconButton(onPressed: () => _editorCtrl.canEditMultipleView?.call(true), icon: const Icon(Icons.select_all)),
                        // IconButton(onPressed: () => _editorCtrl.undo?.call(), icon: const Icon(Icons.undo)),
                        // IconButton(onPressed: () => _editorCtrl.redo?.call(), icon: const Icon(Icons.redo)),
                        IconButton(onPressed: preview, icon: const FaIcon(FontAwesomeIcons.eye)),
                        IconButton(onPressed: saveAsImage, icon: const FaIcon(FontAwesomeIcons.download)),
                      ].reversed.toList(),
                    ),
                  )
                ],
              ),
              // actions: [
              // ],
            ),
          ),
          //
          //
          //
          //
          //
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0.2,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: "Add Text"),
                BottomNavigationBarItem(icon: Icon(Icons.image), label: "Add Image"),
                BottomNavigationBarItem(icon: Icon(Icons.color_lens), label: "Add Background"),
              ],
              onTap: (position) {
                switch (position) {
                  case 0:
                    _addText(null, null);
                    break;
                  case 1:
                    _addImage();
                    break;
                  case 2:
                    _addBackground();
                    break;
                }
              },
            ),
          ),
          //
          //
          //
          //
          //
        ],
      ),
    );
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
  //
  //
  //
  //
  //
  //
  //
  //
  updateText({required String textRaw, TextViewObject? textModel, TextViewStyle? style, int? position}) {
    if (textRaw.isNotEmpty) {
      Navigator.pop(context);

      if (textModel == null) {
        _editorCtrl.addView?.call(view: TextViewObject(text: textRaw, style: style ?? TextViewStyle()));
      } else {
        textModel.text = textRaw;
        _editorCtrl.updateView?.call(position, textModel);
        // style: TextStyle(fontSize: 20.0, color: textColor, fontWeight: FontWeight.bold),
      }
    }
  }

  void _addText(int? position, TextViewObject? textModel) {
    final textValueEditController = TextEditingController(text: textModel?.text);
    final textSizeEditController = TextEditingController(text: textModel?.text);
    TextViewStyle yStyle = textModel?.style ?? TextViewStyle();
    textSizeEditController.text = yStyle.fontSize == null ? '' : '${yStyle.fontSize}';
    final fonts = [null, 'Lato', 'Cairo', 'Rubik Microbe', 'Rubik Glitch']; //, '', '', '', '', '' ,'Alexandria', 'Rubik Distressed',
    showModalBottomSheet(
        // backgroundColor: Colors.transparent,
        // elevation: 2,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, stateSetter) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 380,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textValueEditController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Text',
                                  border: InputBorder.none,
                                ),
                                // style: TextStyle(color: ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(minimumSize: const Size(60, 60)),
                              onPressed: () {
                                yStyle.fontSize = double.tryParse(textSizeEditController.text);
                                updateText(textRaw: textValueEditController.text, textModel: textModel, position: position, style: yStyle);
                              },
                              child: const Text("apply"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        //
                        // STYLeR
                        //
                        Row(
                          children: [
                            const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Color:'))),
                            // const Spacer(),
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _colorArray.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () => stateSetter(() => yStyle.color = _colorArray[index].value),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: yStyle.color != _colorArray[index].value ? null : Border.all(color: Colors.red),
                                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                        color: _colorArray[index],
                                      ),
                                      height: 50.0,
                                      width: 50.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Font Size:'))),
                            const Spacer(),
                            Expanded(
                              child: TextField(
                                controller: textSizeEditController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(hintText: 'Enter Size'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Font Weight:'))),
                            // const Spacer(),
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: FontWeight.values.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () => stateSetter(() => yStyle.fontWeight = index),
                                    child: Container(
                                      decoration: yStyle.fontWeight != index
                                          ? null
                                          : BoxDecoration(
                                              border: Border.all(color: Colors.red),
                                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                            ),
                                      height: 50.0,
                                      width: 50.0,
                                      child: Center(child: Text('Text', style: TextStyle(fontWeight: FontWeight.values[index]))),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Font Family:'))),
                            // const Spacer(),
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: fonts.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () => stateSetter(() => yStyle.fontFamily = fonts[index]),
                                    child: Container(
                                      decoration: yStyle.fontFamily != fonts[index]
                                          ? null
                                          : BoxDecoration(
                                              border: Border.all(color: Colors.red),
                                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                            ),
                                      height: 50.0,
                                      width: 100.0,
                                      child: Center(
                                        child: fonts[index] == null
                                            ? const Text('Normal')
                                            : Text(
                                                fonts[index]!,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.getFont(fonts[index]!),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Font Style:'))),
                            // const Spacer(),
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: FontStyle.values.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () => stateSetter(() => yStyle.fontStyle = index),
                                    child: Container(
                                      decoration: yStyle.fontStyle != index
                                          ? null
                                          : BoxDecoration(
                                              border: Border.all(color: Colors.red),
                                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                            ),
                                      height: 50.0,
                                      width: 50.0,
                                      child: Center(child: Text('Text', style: TextStyle(fontStyle: FontStyle.values[index]))),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  _addBgColor() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 60,
            child: ListView.builder(
              // shrinkWrap: true,
              itemCount: _colorArray.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _editorCtrl.addBackgroundView?.call(BaseViewObject()..backgroundColor = _colorArray[index].value);
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    color: _colorArray[index],
                  ),
                );
              },
            ),
          );
        });
  }

  _addBackground() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                child: const Padding(padding: EdgeInsets.all(20), child: Text("Image Background", style: TextStyle(fontSize: 18.0))),
                onTap: () async {
                  pickOneFilePath(
                    onPick: (image) {
                      if (image != null) {
                        Navigator.pop(context);
                        // _editorCtrl.addBackgroundView?.call(ImageViewObject(raw: image.toList()));
                        _editorCtrl.addBackgroundView?.call(ImageViewObject(path: image));
                      }
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: InkWell(
                child: const Padding(padding: EdgeInsets.all(20), child: Text("Color Background", style: TextStyle(fontSize: 18.0))),
                onTap: () {
                  Navigator.pop(context);
                  _addBgColor();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _addImage() {
    pickOneFilePath(
      onPick: (image) {
        if (image != null) {
          // _editorCtrl.addView?.call(view: ImageViewObject(raw: image.toList(), height: 200, width: 200));
          _editorCtrl.addView?.call(view: ImageViewObject(path: image, height: 200, width: 200));
        }
      },
    );
  }

  _scale() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          var v = _editorCtrl.getModel?.call(null).scale ?? 1.0;
          return SizedBox(
            height: 100,
            child: StatefulBuilder(
              builder: (context, stStt) {
                return Slider(
                  value: v,
                  min: 0.0,
                  max: 2.0,
                  // divisions: 21,
                  onChanged: (value) {
                    // print(value);
                    v = value;
                    stStt(() {});
                    _editorCtrl.scale?.call(null, v);
                  },
                );
              },
            ),
          );
        });
  }

  _rotate() {
    // double current
    showModalBottomSheet(
        context: context,
        builder: (context) {
          var v = _editorCtrl.getModel?.call(null).rotation ?? 0.0;
          return SizedBox(
            height: 100,
            child: StatefulBuilder(
              builder: (context, stStt) {
                return Slider(
                  value: v,
                  min: 0.0,
                  max: 180.0,
                  // divisions: 4,
                  onChanged: (value) {
                    print(value);
                    v = value;
                    stStt(() {});
                    _editorCtrl.rotateView?.call(null, v);
                  },
                );
              },
            ),
          );
        });
  }

  _imageResizer() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 120,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) => setState(() => width = int.tryParse(value)),
                    decoration: const InputDecoration(
                      hintText: 'width',
                      border: InputBorder.none,
                    ),
                  ),
                  TextField(
                    onChanged: (value) => setState(() => height = int.tryParse(value)),
                    decoration: const InputDecoration(
                      hintText: 'height',
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showMenu() {
    dialogMenu(context: context, items: [
      DialogMenuAction(
        icon: const FaIcon(FontAwesomeIcons.broom),
        title: 'New',
        action: () => dialogConfirmation(context: context, onConfirm: () => _editorCtrl.clear?.call()),
      ),
      DialogMenuAction(
        icon: const FaIcon(FontAwesomeIcons.fileImport),
        title: 'Import',
        action: () => dialogConfirmation(context: context, onConfirm: () => importProject()),
      ),
      DialogMenuAction(
        icon: const FaIcon(FontAwesomeIcons.fileExport),
        title: 'Export',
        action: () => dialogConfirmation(context: context, onConfirm: () => saveProject()),
      ),
      DialogMenuAction(
        icon: const FaIcon(FontAwesomeIcons.expand),
        title: 'Image size',
        action: _imageResizer,
      ),
    ]);
  }
}
