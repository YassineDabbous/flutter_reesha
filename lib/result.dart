import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:richa/my_picker.dart';

class Result extends StatelessWidget {
  const Result({key, required this.uint8list}) : super(key: key);

  final Uint8List uint8list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => saveAsImage(context),
              icon: const FaIcon(FontAwesomeIcons.download),
            ),
          ],
        ),
        body: Center(child: Image.memory(uint8list)));
  }

  saveAsImage(BuildContext context) async {
    final path = await pickPathToSave();
    print('save to $path');
    if (path != null) {
      await saveFile(data: uint8list, to: path);
      print('saved to $path');
    } else {
      // if(mounted)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error')));
    }
  }
}
