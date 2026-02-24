import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/enum.dart';
import '../constants/language_global.dart';
import '../constants/sync_global.dart';
import '../models/returned_data_model.dart';

// import 'package:prism_v2/api/global_http.dart';
// import 'package:prism_v2/api/links.dart';
// import 'package:prism_v2/global/enums.dart';
// import 'package:prism_v2/global/sync_global.dart';
// import 'package:prism_v2/model/returned_data_model.dart';
//
// import '../global/language_global.dart';

class LanguagePackService {
  static final LanguagePackService _instance = LanguagePackService._internal();

  factory LanguagePackService() => _instance;

  LanguagePackService._internal();

  //create/get a path for sync file storing
  Future<String> getPath() async {
    Directory baseDir = await getApplicationDocumentsDirectory();
    String langPath = baseDir.path + "v2/language/language.wings";
    return langPath;
  }

  removePreviousLanguagePack() async {
    File? lang = await getLangFile();
    if (lang != null) {
      if (await lang.exists()) {
        await lang.delete();
      }
    }
  }

  //create sync file
  Future<bool> createLangFile() async {
    try {
      String path = await getPath();
      File lang = File(path);
      bool fileExists = await lang.exists();

      if (!fileExists) {
        await lang.create(recursive: true);
        return true;
      } else {
        return true;
      }
    } catch (e) {
      print("inside createLangFile catch block $e");
      return false;
    }
  }

  //get sync file
  Future<File?> getLangFile() async {
    String path = await getPath();
    File lang = File(path);
    if (await lang.exists()) {
      return lang;
    }
  }

  //edit sync file
  Future<bool> writeLang(String text) async {
    try {
      bool langExists = await createLangFile();
      if (langExists) {
        File? lang = await getLangFile();
        await lang!.writeAsString(text);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("writeLang catch block $e");
      return false;
    }
  }

  //get sync file data to an obj
  Future<bool> readLang() async {
    File? lang = await getLangFile();
    if (lang != null) {
      try {
        String txt = await lang.readAsString();
        log(txt);
        Map temp = jsonDecode(txt);
        availableLanguages = [...temp['languages']];
        if(availableLanguages.isEmpty) {
          availableLanguages = ["en"];
        }
        language = temp['locale'];
        langRead = true;
        return true;
      } catch (e, s) {
        print('inside language pack service readlang try catch $e');
        return false;
      }
    } else {
      ReturnedDataModel returnedDataModel = await GlobalHttp(
              httpType: HttpType.get,
              uri: '${Links.baseUrl}${Links.languagePack}')
          .fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        // log(returnedDataModel.data);
        if (returnedDataModel.data['data'].isNotEmpty) {
          bool writeDone =
              await writeLang(jsonEncode(returnedDataModel.data['data']));
          if (writeDone == true) {
            return readLang();
          }
        }
      }
    }
    return false;
  }
}
