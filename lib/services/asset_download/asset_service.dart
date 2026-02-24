import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'asset_download_service.dart';

class AssetService {
  final BuildContext context;

  AssetService(this.context);

  String portID = "";

  //create asset Directory
  Future<bool> createAssetDirectory() async {
    try {
      String path = await AssetDownloadService(context).getBasePath();
      Directory assetDirectory = Directory(path);
      bool directoryExists = await assetDirectory.exists();

      if (!directoryExists) {
        await assetDirectory.create(recursive: true);
        return true;
      } else {
        return true;
      }
    } catch (e, s) {
      print("inside createAssetFile catch block $s");
      return false;
    }
  }

  Future<File?> getAsset(
    String name, {
    required String folder,
    String? version,
  }) async {
    try {
      File? asset;

      await createAssetDirectory();

      String path =
          ('${await AssetDownloadService(context).getBasePath()}/$folder');
      if (version != null) {
        path += "/$version";
      }
      Directory assetDirectory = Directory(path);
      bool directoryExists = await assetDirectory.exists();

      if (!directoryExists) {
        await assetDirectory.create(recursive: true);
      }
      asset = File('${assetDirectory.path}/$name');
      // print("asset path ${asset.path}");
      bool fileExists = await asset.exists();

      if (!fileExists) {
        // final ReceivePort port = ReceivePort();
        // FlutterDownloader.registerCallback(downloadCallback);
        // IsolateNameServer.registerPortWithName(port.sendPort, 'downloader_send_port');
        //
        // await downloadFile(url: '${Links().baseUrl}/static-file/assets/$name', path: path);
        //
        // await for (var data in port) {
        //   if (data[1] == DownloadTaskStatus.complete || data[1] == DownloadTaskStatus.failed || data[1] == DownloadTaskStatus.undefined) {
        //     print("download complete $name");
        //     break;
        //   }
        // }
        //
        // IsolateNameServer.removePortNameMapping('downloader_send_port');
        //
        // port.close();
        //
        await AssetDownloadService(context).downloadFileWithHttp(
          url: '/app-api/static-file/assets/$name',
          path: path,
        );
        return File(asset.path);
      } else {
        return File(asset.path);
      }
    } catch (e, s) {
      print("inside getAsset catch block $e");
      print("inside getAsset catch block $s");
      return null;
    }
  }

  Widget superImage(
    String name, {
    required String folder,
    String? version,
    double? height,
    double? width,
    BoxFit? fit,
    bool isIcon = false,
    String? localAsset,
    bool circular = false,
    String? title,
  }) {
    return FutureBuilder(
      future: getAsset(name, folder: folder, version: version),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(
                circular ? ((height ?? 0) + (width ?? 0)) : 0,
              ),
              child: Image.file(
                snapshot.data as File,
                height: height,
                width: width,
                fit: fit,
                errorBuilder: (context, error, _) {
                  return title == null
                      ? Image.asset(
                    "assets/placeholder-image.png",
                    height: height,
                    width: width,
                  )
                      : CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                      _getTwoLetters(title)  ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            if (isIcon) {
              return const Icon(Icons.image_outlined);
            }
            return title == null
                ? Image.asset(
                    "assets/placeholder-image.png",
                    height: height,
                    width: width,
                  )
                : CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                      _getTwoLetters(title)  ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
          }
        } else {
          if (isIcon) {
            return const Icon(Icons.image_outlined);
          }
          return title == null
              ? Image.asset(
                  "assets/placeholder-image.png",
                  height: height,
                  width: width,
                )
              : CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    _getTwoLetters(title) ?? "",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
        }
      },
    );
  }

  String _getTwoLetters(String name) {
    if (name.isEmpty) return '?';
    name = name.trim();
    if (name.length == 1) return name[0].toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }
}
