import 'dart:convert';

import 'package:richa/editor_new/view_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  // static const _keyTemplates = "_keyTemplates";
  static const _keyTemplate = "_keyTemplate";
  SharedPreferences? preferences;

  SharedPrefHelper();

  init() async {
    preferences ??= await SharedPreferences.getInstance();
  }

// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
// -----------------------------------------------------------------------

  Future<Template?> getTemplate() async {
    await init();
    String? v = preferences?.getString(_keyTemplate);
    // print('☺ SharedPrefHelper ☺ get persisted Template ');
    // print(v);
    return v == null ? null : Template.fromJson(jsonDecode(v));
  }

  Future saveTemplate(Template value) async {
    await init();
    // print('☺ SharedPrefHelper ☺ persist new Template');
    // for (var element in value.objects) {
    //   print(element.toJson());
    //   if (element is TextViewObject) {
    //     print(element.text);
    //   } else {
    //     print('mch TextViewObject');
    //   }
    // }
    preferences?.setString(_keyTemplate, jsonEncode(value.toJson()));
  }
}
