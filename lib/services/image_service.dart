import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wings_olympic_sr/services/helper.dart';
import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../reusable_widgets/language_textbox.dart';
import 'ff_services.dart';

class ImageService {
  File? result;
  Future<File?> compressFile({
    required BuildContext context,
    required File file,
    required String name,
  }) async {
    final dir = await getApplicationDocumentsDirectory();

    final targetPath = '${dir.path}/v2/captures';
    Directory assetDirectory = Directory(targetPath);
    bool directoryExists = await assetDirectory.exists();

    if (!directoryExists) {
      await assetDirectory.create(recursive: true);
    }
    File targetFile = File('$targetPath/$name.jpg');
    if (!targetFile.existsSync()) {
      await targetFile.create(recursive: true);
    }

    try {
      print(file.absolute.path);
      print(targetFile.absolute.path);
      XFile? xFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetFile.absolute.path,
        minWidth: 1200,
        minHeight: 940,
        quality: 50,
      );
      result = xFile == null? null : File(xFile.path);

    } catch (e, s) {
      Helper.dPrint('inside compress image catch block $s');
      // Alerts(context: context).customDialog(
      //   type: AlertType.error,
      //   message: 'Image Compression error',
      // );
    }

    return result;
  }

  sendAndDelete(FileSystemEntity image, String path)async{
    try{
      print(image.path);
      bool done = await sendImage(image.path, path);
      if(done){
        await image.delete();
      }
    }
    catch(e,s){
      print("inside compress Image delete function error: $e $s");
    }
  }

  deleteImageByName(String name)async{
    try {
      final dir = await getApplicationDocumentsDirectory();

      final targetPath = '${dir.path}/v2/captures';
      Directory  targetDir = await Directory(targetPath).create(recursive: true);
      List<FileSystemEntity> files = <FileSystemEntity>[];
      files = await targetDir.list(recursive: false).toList();
      for (FileSystemEntity image in files){
        if(image.path.contains(name)){
          await image.delete();
          break;
        }
      }
    }
    catch(e, s){
      print("Inside CompressedImage deleteImageByName error $e $s");
    }
  }
  Future<File?>getImageByName(String name)async{
    try {
      final dir = await getApplicationDocumentsDirectory();

      final targetPath = '${dir.path}/v2/captures';
      Directory  targetDir = await Directory(targetPath).create(recursive: true);
      List<FileSystemEntity> files = <FileSystemEntity>[];
      files = await targetDir.list(recursive: false).toList();
      for (FileSystemEntity image in files){
        print(image.path);
        if(image.path.contains(name)){
          return File(image.path);
        }
      }
    }
    catch(e, s){
      print("Inside CompressedImage sendAndDeleteImageByName error $e $s");
    }
    return null;
  }
  deleteAllImages()async{
    try {
      final dir = await getApplicationDocumentsDirectory();

      final targetPath = '${dir.path}/v2/captures';
      Directory  targetDir = await Directory(targetPath).create(recursive: true);
      List<FileSystemEntity> files = <FileSystemEntity>[];
      files = await targetDir.list(recursive: false).toList();
      if(files.isNotEmpty){
        for (FileSystemEntity image in files){
          await image.delete();
        }
      }

    }
    catch(e, s){
      print("Inside CompressedImage deleteImageByName error $e $s");
    }
  }

  Future<bool> sendAndDeleteAllImage()async{
    try{
      final dir = await getApplicationDocumentsDirectory();

      final targetPath = '${dir.path}/v2/captures';
      Directory  targetDir = await Directory(targetPath).create(recursive: true);
      List<FileSystemEntity> files = <FileSystemEntity>[];
      files = await targetDir.list(recursive: false).toList();
      for (FileSystemEntity image in files){

        if(image.path.contains(fireflyFolder)){
          // bool done = await sendImage(image.path,fireflyFolder);
          // if(done){
          //   await image.delete();
          // }
          print(image.path);
          if(image.path.contains("newOutlet")){
            await sendAndDelete(image, "$fireflyFolder/newOutlet");
          }
          else {
            await sendAndDelete(image, "$fireflyFolder/changeOutlet");
          }

        }
        /// manual overrrid
        // else if(image.path.contains(manualOverrideFolder)){
        //   SrInfoModel sr = await SyncReadService().getSrInfo();
        //   String date = await SyncReadService().getSalesDate();
        //   DateTime saleDate = DateTime.parse(date);
        //   String path = "$manualOverrideFolder/${saleDate.year}/${saleDate.month}/${saleDate.day.toString().padLeft(2, '0')}/${sr.depId}/${sr.sectionId}";
        //   await sendAndDelete(image, path);
        // }
        /// answer image
        // else {
        //   String quesID = "";
        //   for(int i = 0; i <  image.path.length; i++){
        //     if(image.path[i] == "_"){
        //       break;
        //     }
        //     else {
        //       quesID += image.path[i];
        //     }
        //   }
        //   await sendAndDelete(image, "$answerFolder/$quesID");
        // }


      }
      return true;
    }
    catch(e,s){
      print("inside firefly service deleteImage function error block: $e $s");
      return false;
    }
  }

  Future<bool> sendImage(String imagePath, String path)async{
    try {
      SrInfoModel? srInfo = await FFServices().getSrInfo();
      if(srInfo != null){

        log("${Links.baseUrl}${Links.fileUrl} -> image path ${imagePath}  -> path $path");
        ReturnedDataModel data = await GlobalHttp(uri: "${Links.baseUrl}${Links.fileUrl}",
          httpType: HttpType.file,
          imagePath: imagePath,
          path: path,
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
        ).fetch();
        if(data.status == ReturnedStatus.success){
          if(data.data != null){
            if(data.data.containsKey("success")){
              if(data.data["success"]){
                return true;
              }
            }
          }
        }
      }
    }
    catch(e,s){
      print("inside CompressImage sendImage function catch block error: $e $s");
    }
    return false;
  }

  void showImageBottomSheet({
    required BuildContext context,
    required Function() fromGallery,
    required Function() fromCamera,
    Function()? fromFile,
    bool filePicker = false,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SafeArea(
            bottom: true,
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: [
                ListTile(
                  onTap: () {
                    fromGallery();
                    Navigator.pop(context);
                  },
                  title: LangText(
                    'Tap to open gallery',
                  ),
                  leading: const Icon(
                    Icons.image_rounded,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next_rounded,
                    size: 16,
                  ),
                ),
                ListTile(
                  onTap: () {
                    fromCamera();
                    Navigator.pop(context);
                  },
                  title: LangText(
                    'Tap to open camera',
                  ),
                  leading: const Icon(Icons.camera_alt_rounded),
                  trailing: const Icon(
                    Icons.navigate_next_rounded,
                    size: 16,
                  ),
                ),
                Visibility(
                  visible: filePicker,
                  child: ListTile(
                    onTap: () {
                      fromFile!();
                      Navigator.pop(context);
                    },
                    title: LangText(
                      'Tap to open file',
                    ),
                    leading: const Icon(Icons.file_copy_rounded),
                    trailing: const Icon(
                      Icons.navigate_next_rounded,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
