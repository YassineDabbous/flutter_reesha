// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Template _$TemplateFromJson(Map<String, dynamic> json) => Template(
      name: json['name'] as String,
      objects: (json['objects'] as List<dynamic>)
          .map((e) => BaseViewObject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
      'name': instance.name,
      'objects': instance.objects,
    };

Map<String, dynamic> _$BaseViewObjectToJson(BaseViewObject instance) =>
    <String, dynamic>{
      'type': instance.type,
      'index': instance.index,
      'scale': instance.scale,
      'rotation': instance.rotation,
      'left': instance.left,
      'top': instance.top,
      'height': instance.height,
      'width': instance.width,
      'backgroundColor': instance.backgroundColor,
    };

ImageViewObject _$ImageViewObjectFromJson(Map<String, dynamic> json) =>
    ImageViewObject(
      path: json['path'] as String,
      height: (json['height'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
    )
      ..type = json['type'] as String?
      ..index = json['index'] as int
      ..scale = (json['scale'] as num?)?.toDouble()
      ..rotation = (json['rotation'] as num?)?.toDouble()
      ..left = json['left'] as int?
      ..top = json['top'] as int?
      ..backgroundColor = json['backgroundColor'] as int?;

Map<String, dynamic> _$ImageViewObjectToJson(ImageViewObject instance) =>
    <String, dynamic>{
      'type': instance.type,
      'index': instance.index,
      'scale': instance.scale,
      'rotation': instance.rotation,
      'left': instance.left,
      'top': instance.top,
      'height': instance.height,
      'width': instance.width,
      'backgroundColor': instance.backgroundColor,
      'path': instance.path,
    };

TextViewObject _$TextViewObjectFromJson(Map<String, dynamic> json) =>
    TextViewObject(
      text: json['text'] as String,
      style: TextViewStyle.fromJson(json['style'] as Map<String, dynamic>),
    )
      ..type = json['type'] as String?
      ..index = json['index'] as int
      ..scale = (json['scale'] as num?)?.toDouble()
      ..rotation = (json['rotation'] as num?)?.toDouble()
      ..left = json['left'] as int?
      ..top = json['top'] as int?
      ..height = (json['height'] as num?)?.toDouble()
      ..width = (json['width'] as num?)?.toDouble()
      ..backgroundColor = json['backgroundColor'] as int?;

Map<String, dynamic> _$TextViewObjectToJson(TextViewObject instance) =>
    <String, dynamic>{
      'type': instance.type,
      'index': instance.index,
      'scale': instance.scale,
      'rotation': instance.rotation,
      'left': instance.left,
      'top': instance.top,
      'height': instance.height,
      'width': instance.width,
      'backgroundColor': instance.backgroundColor,
      'text': instance.text,
      'style': instance.style,
    };

TextViewStyle _$TextViewStyleFromJson(Map<String, dynamic> json) =>
    TextViewStyle(
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontFamily: json['fontFamily'] as String?,
      color: json['color'] as int?,
      fontStyle: json['fontStyle'] as int?,
      fontWeight: json['fontWeight'] as int?,
    )
      ..type = json['type'] as String?
      ..index = json['index'] as int
      ..scale = (json['scale'] as num?)?.toDouble()
      ..rotation = (json['rotation'] as num?)?.toDouble()
      ..left = json['left'] as int?
      ..top = json['top'] as int?
      ..height = (json['height'] as num?)?.toDouble()
      ..width = (json['width'] as num?)?.toDouble()
      ..backgroundColor = json['backgroundColor'] as int?;

Map<String, dynamic> _$TextViewStyleToJson(TextViewStyle instance) =>
    <String, dynamic>{
      'type': instance.type,
      'index': instance.index,
      'scale': instance.scale,
      'rotation': instance.rotation,
      'left': instance.left,
      'top': instance.top,
      'height': instance.height,
      'width': instance.width,
      'backgroundColor': instance.backgroundColor,
      'fontSize': instance.fontSize,
      'fontFamily': instance.fontFamily,
      'color': instance.color,
      'fontWeight': instance.fontWeight,
      'fontStyle': instance.fontStyle,
    };
