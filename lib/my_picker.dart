import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

// Future pickOneFilePath({required Function(String?) onPick, FileType type = FileType.any, List<String>? allowedExtensions}) async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(type: type, allowMultiple: false, withData: true, allowedExtensions: allowedExtensions);
//   if (result != null) {
//     onPick(result.files.single.path);
//   } else {
//     onPick(null);
//   }
// }
Future<File> saveFile({required Uint8List data, required String to}) async {
  // final File temp = await createTemporaryFile('name.tmp');
  // return await temp.copy(to);
  final file = File(to);
  return await file.writeAsBytes(data);
}

Future<String?> pickPathToSave() async {
  return await FilePicker.platform.saveFile();
}

Future pickOne({required FileType type, required Function(Uint8List?) onPick}) async {
  if (type == FileType.image) {
    await pickOneImage(onPick: onPick);
  } else if (type == FileType.video) {
    await pickOneVideo(onPick: onPick);
  } else if (type == FileType.audio) {
    await pickOneAudio(onPick: onPick);
  }
  // else if (type == FileType.SVG) {
  //   await pickOneSvg(onPick: onPick);
  // } else if (type == FileType.GLTF) {
  //   await pickOneGltf(onPick: onPick);
  // }
  else {
    await pickOneFileData(onPick: onPick);
  }
}

Future pickOneAudio({required Function(Uint8List?) onPick}) async {
  await pickOneFileData(onPick: onPick, type: FileType.audio);
}

Future pickOneImage({required Function(Uint8List?) onPick}) async {
  await pickOneFileData(onPick: onPick, type: FileType.image);
}

Future pickOneSvg({required Function(Uint8List?) onPick}) async {
  await pickOneFileData(onPick: onPick, type: FileType.custom, allowedExtensions: ['svg']);
}

Future pickOneGltf({required Function(Uint8List?) onPick}) async {
  await pickOneFileData(onPick: onPick, type: FileType.custom, allowedExtensions: ['gltf', 'glb']);
}

Future pickOneVideo({required Function(Uint8List?) onPick}) async {
  await pickOneFileData(onPick: onPick, type: FileType.video);
}

Future pickOneFileData({required Function(Uint8List?) onPick, FileType type = FileType.any, List<String>? allowedExtensions}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: type, allowMultiple: false, withData: true, allowedExtensions: allowedExtensions);
  if (result != null) {
    Uint8List? file = result.files.single.bytes;
    onPick(file);
  } else {
    onPick(null);
  }
}

Future pickOneFilePath({required Function(String?) onPick, FileType type = FileType.any, List<String>? allowedExtensions}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: type, allowMultiple: false, withData: true, allowedExtensions: allowedExtensions);
  if (result != null) {
    onPick(result.files.single.path);
  } else {
    onPick(null);
  }
}

Future pickMulti(Function(List<Uint8List?>?) onPick) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
  if (result != null) {
    //List<File> files = result.paths.map((path) => File(path!)).toList();
    List<Uint8List?> files = result.files.map((file) => file.bytes).toList();
    onPick(files);
  } else {
    onPick(null);
  }
}
