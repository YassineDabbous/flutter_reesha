import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_annotation/json_annotation.dart';
part 'view_object.g.dart';

@JsonSerializable()
class Template {
  final String name;
  final List<BaseViewObject> objects;
  Template({required this.name, required this.objects});
  factory Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateToJson(this)..removeWhere((key, value) => value == null);
}

@JsonSerializable(createFactory: false)
class BaseViewObject {
  String? type;
  int index = 0;
  double? scale; //= 1.0
  double? rotation; // = 0;
  int? left; // = 0;
  int? top; // = 0;
  double? height;
  double? width;
  int? backgroundColor; // = 0xffffff;
  @JsonKey(ignore: true)
  Matrix4? matrix4;
  fillMatrix() {
    matrix4 = Matrix4.identity();
    if (top != null && left != null) {
      matrix4?.translate(left!.toDouble(), top!.toDouble());
    }
    if (rotation != null) {
      matrix4?.rotateY(rotation!);
    }
    // if (scale != null) { canceled , scale should be calculated in build only
    //   matrix4?.scale(scale);
    // }
    //..
  }

  //

  BaseViewObject({this.height, this.width}) {
    type = '$runtimeType';
  }
  Map<String, dynamic> toJson() => _$BaseViewObjectToJson(this)..removeWhere((key, value) => value == null);
  // factory BaseViewObject.fromJson(Map<String, dynamic> json) => _$BaseViewObjectFromJson(json)..fillMatrix();
  factory BaseViewObject.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'ImageViewObject') {
      return ImageViewObject.fromJson(json)..fillMatrix();
    }
    if (json['type'] == 'TextViewObject') {
      return TextViewObject.fromJson(json)..fillMatrix();
    }
    return BaseViewObject.fromJson(json)..fillMatrix();
  }
}

@JsonSerializable()
class ImageViewObject extends BaseViewObject {
  String path;
  File get file => File(path);
  //
  ImageViewObject({required this.path, super.height, super.width}) {
    type = '$runtimeType';
  }
  factory ImageViewObject.fromJson(Map<String, dynamic> json) => _$ImageViewObjectFromJson(json)..fillMatrix();
  @override
  Map<String, dynamic> toJson() => _$ImageViewObjectToJson(this)..removeWhere((key, value) => value == null);
}
// @JsonSerializable()
// class ImageViewObject extends BaseViewObject {
//   String? path;
//   Uint8List get data => Uint8List.fromList(raw);
//   List<int> raw;
//   //
//   ImageViewObject({required this.raw, this.path, super.height, super.width});
//   factory ImageViewObject.fromJson(Map<String, dynamic> json) => _$ImageViewObjectFromJson(json);
//   @override
//   Map<String, dynamic> toJson() => _$ImageViewObjectToJson(this)..removeWhere((key, value) => value == null);
// }

@JsonSerializable()
class TextViewObject extends BaseViewObject {
  String text;
  TextViewStyle style;

  TextViewObject({required this.text, required this.style}) {
    type = '$runtimeType';
  }
  factory TextViewObject.fromJson(Map<String, dynamic> json) => _$TextViewObjectFromJson(json)..fillMatrix();
  @override
  Map<String, dynamic> toJson() => _$TextViewObjectToJson(this)..removeWhere((key, value) => value == null);
}

@JsonSerializable()
class TextViewStyle extends BaseViewObject {
  int? color;
  double? fontSize;
  String? fontFamily;
  int? fontWeight;
  int? fontStyle;
  Color? get colorFlutter => color == null ? null : Color(color!);
  FontWeight? get fontWeightFlutter => fontWeight == null ? null : FontWeight.values.elementAt(fontWeight!);
  FontStyle? get fontStyleFlutter => fontStyle == null ? null : FontStyle.values.elementAt(fontStyle!);
  TextStyle? get styleFlutter {
    final ts = fontFamily == null
        ? TextStyle(
            // fontFamily: fontFamily,
            color: colorFlutter,
            fontSize: fontSize,
            fontWeight: fontWeightFlutter,
            fontStyle: fontStyleFlutter,
          )
        : GoogleFonts.getFont(
            fontFamily!,
            color: colorFlutter,
            fontSize: fontSize,
            fontWeight: fontWeightFlutter,
            fontStyle: fontStyleFlutter,
          );
    // ts.copyWith(
    //   color: colorFlutter,
    //   fontSize: fontSize,
    //   // fontFamily: fontFamily,
    //   fontWeight: fontWeightFlutter,
    //   fontStyle: fontStyleFlutter,
    // );
    return ts;
  }

  TextViewStyle({
    this.fontSize,
    this.fontFamily,
    this.color,
    this.fontStyle,
    this.fontWeight,
  });
  factory TextViewStyle.fromJson(Map<String, dynamic> json) => _$TextViewStyleFromJson(json)..fillMatrix();
  @override
  Map<String, dynamic> toJson() => _$TextViewStyleToJson(this)..removeWhere((key, value) => value == null);
}
