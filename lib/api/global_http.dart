import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../constants/enum.dart';
import '../models/returned_data_model.dart';
import '../services/connectivity_service.dart';
import '../services/helper.dart';

class GlobalHttp {
  final String uri;
  final HttpType httpType;
  final String? accessToken;
  final String? refreshToken;
  Uint8List? byteImage;
  String? imagePath;
  String? body;
  Map? otherDataWithImage;
  String? imageHeader;
  HttpType? imageRequestType;
  String? path;
  Map<String, dynamic>? queryParameters;

  GlobalHttp({
    required this.uri,
    required this.httpType,
    this.body,
    this.otherDataWithImage,
    this.byteImage,
    this.imagePath,
    this.accessToken,
    this.refreshToken,
    this.path,
    this.imageHeader,
    this.imageRequestType,
    this.queryParameters,
  });

  Future<ReturnedDataModel> fetch() async {
    var response;

    //bool isOnline = await ConnectivityService().checkInternet();
    bool isOnline = true;
    if (isOnline) {
      try {
        var url = Uri.parse(uri).replace(queryParameters: queryParameters);

        Map<String, String> header = {'Accept': 'application/json', 'Content-Type': 'application/json'};
        if (accessToken != null) {
          header['Authorization'] = "Bearer $accessToken";
        }
        if (refreshToken != null) {
          header["refreshToken"] = refreshToken!;
        }
        String responseStr = "";
        switch (httpType) {
          case HttpType.get:
            response = await http.get(
              url,
              headers: header,
            );
            responseStr = response.body;
            break;
          case HttpType.post:
            response = await http.post(
              url,
              headers: header,
              body: body,
            );
            responseStr = response.body;
            break;
          case HttpType.patchWithoutFile:
            response = await http.patch(
              url,
              headers: header,
              body: body,
            );
            responseStr = response.body;
            break;
          case HttpType.delete:
            response = await http.delete(
              url,
              headers: header,
              body: body,
            );
            responseStr = response.body;
            break;
          case HttpType.patch:
            // response = http.patch(url, headers: header);
            // responseStr = await response.stream.bytesToString();
            var request = http.Request('PATCH', url);
            request.body = body ?? "";
            request.headers.addAll(header);
            response = await request.send();
            responseStr = await response.stream.bytesToString();
            break;
          case HttpType.file:
            print('file type payload--> ${otherDataWithImage}');
            var req = http.MultipartRequest(imageRequestType == HttpType.post || imageRequestType == null ? "POST" : "PATCH", url);
            req.headers.addAll(header);
            if (imagePath != null) {
              req.files.add(await http.MultipartFile.fromPath(imageHeader ?? "file", imagePath!));
            }
            if (otherDataWithImage != null) {
              for (MapEntry otherDataEntry in otherDataWithImage!.entries) {
                String key = otherDataEntry.key.toString();
                // dynamic value = otherDataEntry
                req.fields[key] = otherDataWithImage![key].toString();
              }
            } else {
              req.fields["path"] = path ?? "others";
            }

            response = await req.send();
            responseStr = await response.stream.bytesToString();
          log('------> $response');
          log('------> $responseStr');
        }

        var jsonData = jsonDecode(responseStr);
        // log('response ------> $jsonData');

        try {
          log('\n🌐 url --> $uri \n🤯 headers --> $header\n💤 request --> ${httpType.name} \n🔢 status code --> ${response.statusCode}\n🛢 payload --> $body\n🛢️ response --> ${jsonEncode(jsonData)}');
        } catch (e) {
          Helper.dPrint('error is:: ${e.toString()}');
        }
        if (jsonData['success'] == true || jsonData['status'] == true) {
          return ReturnedDataModel(status: ReturnedStatus.success, data: jsonData);
        } else {
          return ReturnedDataModel(status: ReturnedStatus.error, errorMessage: jsonData['message'].toString());
        }
      } catch (e, s) {
        print('global http class catch block : $e');
        print('global http class catch block : $s');
        return ReturnedDataModel(status: ReturnedStatus.error, errorMessage: e.toString());
      }
    } else {
      return ReturnedDataModel(status: ReturnedStatus.error, errorMessage: 'No Internet connection');
    }
  }
}
