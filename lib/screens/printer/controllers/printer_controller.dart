import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/module.dart';
import '../../../models/sr_info_model.dart';
import '../../../models/trade_promotions/applied_discount_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/sync_read_service.dart';
import '../../../utils/promotion_utils.dart';
import '../../print_memo/model/load_summaryDetailsModel.dart';
import '../../print_memo/model/load_summary_model.dart';
import '../../print_memo/model/retailer_wise_memo_data.dart';
import '../../print_memo/model/trip_wise_memo_data.dart';
import '../../print_memo/service/print_memo_service.dart';

class PrinterController {
  final BuildContext context;
  final WidgetRef ref;
  late final Alerts _alerts;
  BlueThermalPrinter _bluetooth;
  final SyncReadService _syncReadService;

  PrinterController({required this.context, required this.ref})
      : _alerts = Alerts(context: context),
        _bluetooth = BlueThermalPrinter.instance,
        _syncReadService = SyncReadService();

  final _printMemoService = PrintMemoService();

  //connecting to bluetooth
  Future<bool> _connect(BluetoothDevice device) async {
    try {
      bool isConnected = await _bluetooth.isConnected ?? false;
      if (!isConnected) {
        try {
          // await _bluetooth.disconnect();
          await _bluetooth.connect(device);
          // bool con = await _bluetooth.isConnected ?? false;
        } catch (e, s) {
          print("bluetooth connection error $e $s");
        }
      }
      return await _bluetooth.isConnected ?? false;
    } catch (e, s) {
      print("inside bluetooth connect function error $e $s");
      return false;
    }
  }

  Future<BluetoothDevice?> getBluetoothDevice() async {
    List<BluetoothDevice> devices = [];
    BluetoothDevice? device;
    try {
      devices = await _bluetooth.getBondedDevices();
      if (devices.isNotEmpty) {
        device = devices[0];
        // for (BluetoothDevice d in devices) {
        //   if (d.name != null) {
        //     if (d.name!.contains("PTP")) {
        //       device = d;
        //       break;
        //     }
        //   }
        // }
        return device;
      }
    } catch (e) {
      print(
          "no bluetooth devices found getBluetoothDevice printerController catch block $e");
    }
  }

  Future<bool> configureBluetoothPrinter([bool first = false]) async {
    bool success = false;
    try {
      PrinterStatus prevConnectedStatus = ref.read(printerConnectedProvider);

      if (await _bluetooth.isOn ?? false) {
        BluetoothDevice? device = await getBluetoothDevice();
        if (prevConnectedStatus == PrinterStatus.connected) {
          if (!first) {
            await _bluetooth.disconnect();
          } else {
            success = true;
          }
          device = null;
        }

        if (device != null) {
          // _alerts.floatingLoading()
          ref.read(printerConnectedProvider.state).state =
              PrinterStatus.reconnecting;
          bool isConnected = await _connect(device);
          // Navigator.pop(context);
          if (isConnected) {
            success = true;
          } else {
            _alerts.snackBar(
                massage: "Bluetooth printer is not connected",
                isSuccess: false);
          }
        }
      } else {
        _alerts.snackBar(massage: "Please turn on bluetooth", isSuccess: false);
      }
    } catch (e, s) {
      print(
          "inside configureBluetoothPrinter printerController catch block $e");
      print(
          "inside configureBluetoothPrinter printerController catch block $s");
    }
    // ref.read(isPrinterConnectedProvider.state).state = success;
    if (success) {
      _alerts.snackBar(massage: "Printer Connected");
      ref.read(printerConnectedProvider.state).state = PrinterStatus.connected;
    } else {
      // _alerts.snackBar(massage: "Printer Disconnected", isSuccess: false);
      ref.read(printerConnectedProvider.state).state =
          PrinterStatus.disconnected;
    }
    return success;
  }


  Future<bool> connectBluetoothPrinter() async {
    bool success = false;
    try {
      PrinterStatus prevConnectedStatus = ref.read(printerConnectedProvider);
      if (await _bluetooth.isOn ?? false) {
        BluetoothDevice? device = await getBluetoothDevice();
        if (prevConnectedStatus == PrinterStatus.connected) {
          // await _bluetooth.disconnect();
          bool connected = await _bluetooth.isConnected ?? false;
          if (connected) {
            success = true;
          }

          // device = null;
        }
        if (device != null && !success) {
          // _alerts.floatingLoading()
          ref.read(printerConnectedProvider.state).state =
              PrinterStatus.reconnecting;
          bool isConnected = await _connect(device);
          // Navigator.pop(context);
          if (isConnected) {
            success = true;
          } else {
            _alerts.snackBar(
                massage: "Bluetooth printer is not connected",
                isSuccess: false);
          }
        }
      } else {
        _alerts.snackBar(massage: "Please turn on bluetooth", isSuccess: false);
      }
    } catch (e, s) {
      print(
          "inside configureBluetoothPrinter printerController catch block $e");
      print(
          "inside configureBluetoothPrinter printerController catch block $s");
    }
    // ref.read(isPrinterConnectedProvider.state).state = success;
    if (success) {
      // _alerts.snackBar(massage: "Printer Connected");
      ref.read(printerConnectedProvider.state).state = PrinterStatus.connected;
    } else {
      // _alerts.snackBar(massage: "Printer Disconnected", isSuccess: false);
      ref.read(printerConnectedProvider.state).state =
          PrinterStatus.disconnected;
    }
    return success;
  }

  Future<File> getImageFileFromAssets(String path, String name) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$name');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  // String allowedCharacters = """ 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~""";

  printMemo({required Map<String, List<LoadSummaryDetails>> loadSummary, required LoadSummaryModel loadSummaryModel}) async {

    // List<String> characters = allowedCharacters.split("");
    List<LoadSummaryDetails> finalLoadSummary = [];
    List<LoadSummarySkus> allSkus = [];
    Map<int, Uint8List> allSkuUnit8List = {};

    loadSummary.forEach((key, value) {
      for(var load in value) {
        if(load.skus != null) {
          allSkus.addAll(load.skus!);
        }
      }
      finalLoadSummary.addAll(value);
    });

    ///generate skus name unit8List
    for(var sku in allSkus) {
      if(!allSkuUnit8List.containsKey(sku.skuId)) {
        allSkuUnit8List[sku.skuId ?? 0] = await createTextImage(
          sku.formatedSku?.name ?? "",
        );
      }
    }

    SrInfoModel sr = await _syncReadService.getSrInfo();

    try {
      List<LoadSummaryDetails> finalLoadSummary = [];
      List<LoadSummarySkus> allSkus = [];
      Map<int, Uint8List> allSkuUnit8List = {};

      loadSummary.forEach((key, value) {
        for(var load in value) {
          if(load.skus != null) {
            allSkus.addAll(load.skus!);
          }
        }
        finalLoadSummary.addAll(value);
      });

      ///generate skus name unit8List
      for(var sku in allSkus) {
        if(!allSkuUnit8List.containsKey(sku.skuId)) {
          allSkuUnit8List[sku.skuId ?? 0] = await createTextImage(
             "${sku.formatedSku?.name}".trim(),
          );
        }
      }

      SrInfoModel sr = await _syncReadService.getSrInfo();

      int limit = 0;
      for(var memo in finalLoadSummary) {
        // if(limit == 1 && kDebugMode) {
        //   return;
        // }
        // limit++;
        if (PrintMemoService.isValidString(memo.outletName ?? "")) {
          // print48Title(title: "Outlet name: ", data: memo.outletName ?? "");
          _bluetooth.printCustom("Outlet name: ${memo.outletName}".trim(), 1, 0);
        } else {
          final owner =  await createCombinationTextImage("Outlet name: ${memo.outletName}".trim());
          _bluetooth.printImageBytes(owner);
        }

        // print48Title(title: "Outlet Code: ", data: memo.outletCode ?? "");
        _bluetooth.printCustom("Outlet Code: ${memo.outletCode}", 1, 0);

        if (PrintMemoService.isValidString(memo.ownerName ?? "")) {
          _bluetooth.printCustom("Owner name: ${memo.ownerName}".trim(), 1, 0);
        } else {
          final address =  await createCombinationTextImage("Owner name: ${memo.ownerName}".trim());

          _bluetooth.printImageBytes(address);
        }

        if (PrintMemoService.isValidString(memo.address ?? "")) {
          // print48Title(title: "Address: ", data: "-");
          _bluetooth.printCustom("Address: ${memo.address}".trim(), 1, 0);
        } else {
          final owner =  await createCombinationTextImage("Address: ${memo.address}".trim());
          _bluetooth.printImageBytes(owner);
        }

        if (PrintMemoService.isValidString(sr.fullname ?? "")) {
          // print48Title(title: "SO Name: ", data: sr.fullname);
          _bluetooth.printCustom("SO Name: ${sr.fullname}".trim(), 1, 0);
        } else {
          final owner =  await createCombinationTextImage("SO Name: ${sr.fullname}".trim());
          _bluetooth.printImageBytes(owner);
        }

        _bluetooth.printNewLine();
        _bluetooth.printNewLine();
        print64Title(leftData: "Preorder: ${loadSummaryModel.orderDate}", rightData: "Delivery: ${loadSummaryModel.date}");
        print64Title(leftData: "Route: ${memo.route}", rightData: "Mob No.: ${memo.contactNumber}");
        _bluetooth.printNewLine();

        _bluetooth.printCustom("----------------------------------------------------------------", 0, 0);
        print64SkuInfo(title: "SKU", qty: "Qty", total: "Total", offer: "Offer", payable: "Payable");
        _bluetooth.printCustom("----------------------------------------------------------------", 0, 0);
        _bluetooth.printNewLine();
        final skusList = await _printMemoService.printingMemoByOutlet(loadSumSku: memo.skus);

        for(RetailerWiseMemoData sku in skusList) {
          if(allSkuUnit8List.containsKey(sku.formatedSku.id)) {
            _bluetooth.printImageBytes(allSkuUnit8List[sku.formatedSku.id]!);
          } else {
            _bluetooth.printImageBytes(await createTextImage(
              sku.formatedSku.name.trim(),
            ));
          }
          print64SkuInfo(
            title: "",
            qty: _printMemoService.getFormatedQty(sku),
            total: "${sku.total}",
            offer: sku.offer==0? "-" : "-${sku.offer}",
            payable: "${sku.payable}",
          );
          _bluetooth.printNewLine();
        }
        // for(LoadSummarySkus sku in memo.skus ?? []) {
        //   _bluetooth.printImageBytes(allSkuUnit8List[sku.skuId]!);
        //   print64SkuInfo(
        //       title: "",
        //       qty: _printMemoService.getFormatedQTY(sku),
        //       total: _printMemoService.getFormatedTotal(sku).toString(),
        //       offer: _printMemoService.getFormatedOffer(sku).toString(),
        //       payable: _printMemoService.getFormatedPayable(sku).toString(),
        //   );
        //   await _checkCrossProductPromotion(sku);
        //   _bluetooth.printNewLine();
        // }
        // num totalPrice = memo.skus?.map((p) => p.totalPrice).fold(0, (a, b) => (a ?? 0) + (b ?? 0)) ?? 0;
        _bluetooth.printCustom("----------------------------------------------------------------", 0, 0);
        print64SkuInfo(
            title: "Total",
            qty: _printMemoService.getFormatedTotalQTY(memo),
            total: _printMemoService.getFormatedTotalTotal(memo),
            offer: _printMemoService.getFormatedTotalOffer(memo),
            payable: _printMemoService.getFormatedTotalPayable(memo),
        );
        _bluetooth.printCustom("----------------------------------------------------------------", 0, 0);

        _bluetooth.paperCut();
      }

    } catch (e, s) {
      print("inside printStock printerController catch block $e");
      print("inside printStock printerController catch block $s");
    }
  }

  printLoadSummary({required Map<String, List<LoadSummaryDetails>> loadSummary, required LoadSummaryModel loadSummaryModel}) async {

    List<LoadSummaryDetails> finalLoadSummary = [];
    List<LoadSummarySkus> allSkus = [];
    Map<int, Uint8List> allSkuUnit8List = {};

    loadSummary.forEach((key, value) {
      for(var load in value) {
        if(load.skus != null) {
          allSkus.addAll(load.skus!);
        }
      }
      finalLoadSummary.addAll(value);
    });

    ///generate skus name unit8List
    for(var sku in allSkus) {
      if(!allSkuUnit8List.containsKey(sku.skuId)) {
        allSkuUnit8List[sku.skuId ?? 0] = await createTextImage(
          sku.formatedSku?.name ?? "",
        );
      }
    }

    SrInfoModel sr = await _syncReadService.getSrInfo();

    try {
      List<LoadSummaryDetails> finalLoadSummary = [];
      List<LoadSummarySkus> allSkus = [];
      Map<int, Uint8List> allSkuUnit8List = {};

      loadSummary.forEach((key, value) {
        for(var load in value) {
          if(load.skus != null) {
            allSkus.addAll(load.skus!);
          }
        }
        finalLoadSummary.addAll(value);
      });

      SrInfoModel sr = await _syncReadService.getSrInfo();

      _bluetooth.printCustom("Daily Delivery Chalan".trim(), 2, 1);
      _bluetooth.printNewLine();

      _bluetooth.printCustom("Delivery Date : ${loadSummaryModel.date}".trim(), 1, 0);

      if (PrintMemoService.isValidString(loadSummaryModel.pint ?? "")) {
        _bluetooth.printCustom("Point: ${loadSummaryModel.pint}".trim(), 1, 0);
      } else {
        final owner =  await createCombinationTextImage("Point: ${loadSummaryModel.pint}".trim());
        _bluetooth.printImageBytes(owner);
      }

      if (PrintMemoService.isValidString(loadSummaryModel.address ?? "")) {
        _bluetooth.printCustom("Address: ${loadSummaryModel.address}".trim(), 1, 0);
      } else {
        final owner =  await createCombinationTextImage("Address: ${loadSummaryModel.address}".trim());
        _bluetooth.printImageBytes(owner);
      }

      String routName = "";
      loadSummary.forEach((key, value) {
        routName = value.first.route ?? "";
      });
      if (PrintMemoService.isValidString(routName ?? "")) {
        _bluetooth.printCustom("Route: $routName".trim(), 1, 0);
      } else {
        final owner =  await createCombinationTextImage("Route: $routName".trim());
        _bluetooth.printImageBytes(owner);
      }

      if (PrintMemoService.isValidString(loadSummaryModel.name ?? "")) {
        _bluetooth.printCustom("Vehicle: ${loadSummaryModel.name}".trim(), 1, 0);
      } else {
        final owner =  await createCombinationTextImage("Vehicle: ${loadSummaryModel.name}".trim());
        _bluetooth.printImageBytes(owner);
      }

      if (PrintMemoService.isValidString(loadSummaryModel.vehicleCapacity ?? "")) {
        _bluetooth.printCustom("Capacity: ${loadSummaryModel.vehicleCapacity}".trim(), 1, 0);
      } else {
        final owner =  await createCombinationTextImage("Capacity: ${loadSummaryModel.vehicleCapacity}".trim());
        _bluetooth.printImageBytes(owner);
      }

      if (PrintMemoService.isValidString(loadSummaryModel.dsrName ?? "")) {
        _bluetooth.printCustom("DSR: ${loadSummaryModel.dsrName}".trim(), 1, 0);
      } else {
        final owner =  await createCombinationTextImage("DSR: ${loadSummaryModel.dsrName}".trim());
        _bluetooth.printImageBytes(owner);
      }

      if (PrintMemoService.isValidString(sr.fullname ?? "")) {
        _bluetooth.printCustom("SO: ${sr.fullname}".trim(), 1, 0);
      } else {
        final owner =  await createCombinationTextImage("SO: ${sr.fullname}".trim());
        _bluetooth.printImageBytes(owner);
      }

      _bluetooth.printNewLine();
      _generateTitleBar(loadSummary);
      final skusList = await _printMemoService.getAllTripLoadSummaryDetails(loadSummary: loadSummary);
      int limit = 0;
      for(TripWiseMemoData sku in skusList) {
        _bluetooth.printCustom("----------------------------------------------------------------", 0, 0);
        _bluetooth.printCustom(sku.formatedSku.name, 0, 0);
        _generateSkuAndSales(loadSummary, sku);
        // _bluetooth.printCustom("----   Damage   --------   Total Sold   ---------   Price   ----", 0, 0);
        // _bluetooth.printCustom("                   |                        |                   ", 0, 0);
      }

      _bluetooth.printCustom("------------------------------------------------", 1, 0);
      _getTotalRow(skusList, loadSummary);
      _bluetooth.printCustom("------------------------------------------------", 1, 0);
      _bluetooth.paperCut();

    } catch (e, s) {
      print("inside printStock printerController catch block $e");
      print("inside printStock printerController catch block $s");
    }
  }

  bool isValidString(String text, List<String> allowedChars) {
    return text.split('').every((char) => allowedChars.contains(char));
  }

  Future<Uint8List> assetImageToUint8List(String assetPath) async {
    ByteData byteData = await rootBundle.load(assetPath);
    Uint8List uint8List = byteData.buffer.asUint8List();
    return uint8List;
  }

  Future<Uint8List> createReceiptImage({
    required int index,
    required String name,
    required String qty,
    required String offer,
    required String amount,
    Color backgroundColor = Colors.white,
  }) async {
    final TextStyle titleStyle = TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);
    final TextStyle textStyle = TextStyle(fontSize: 22, color: Colors.black);

    final TextPainter titlePainter = TextPainter(
      text: TextSpan(text: name, style: titleStyle),
      textAlign: TextAlign.left,
      textDirection: ui.TextDirection.ltr,
    )..layout();

    final TextPainter rowPainter = TextPainter(
      text: TextSpan(
        text: "$index  $qty                      $offer      $amount",
        style: textStyle,
      ),
      textAlign: TextAlign.left,
      textDirection: ui.TextDirection.ltr,
    )..layout();

    final double width = titlePainter.width + 40;
    final double height = titlePainter.height + rowPainter.height + 20;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // Draw background
    final Paint paint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // Draw text
    titlePainter.paint(canvas, Offset(10, 5));
    rowPainter.paint(canvas, Offset(10, titlePainter.height + 10));

    final ui.Image img =
        await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final ByteData? byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<String?> _getModifiedPathForMemo() async {
    try {
      bool permission = true; //await _requestPermission();
      if (permission == true) {
        Directory? directory = await getExternalStorageDirectory();
        if (directory != null) {
          String path = "";
          List<String> paths = directory.path.split("/");
          for (String p in paths) {
            if (p != "Android") {
              path += "/$p";
            } else {
              break;
            }
          }
          path += "/PrismMemo/${apiDateFormat.format(DateTime.now())}/";
          Directory newDirectory = Directory(path);
          if (!await newDirectory.exists()) {
            await directory.create(recursive: true);
          }

          return newDirectory.path;
        }
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return null;
  }

  Future<Uint8List> loadImageFromAssets(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<Uint8List> loadPdfFromAssets(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<Uint8List> createTextImage(
    String text, {
    TextStyle? style,
    Color backgroundColor = Colors.white,
  }) async {
    final TextStyle effectiveStyle = style ??
        const TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: ui.FontWeight.bold);
    // if(text.length > 37) {
    //   text=
    // }
    final textSpan = TextSpan(text: text.trim(), style: effectiveStyle);
    final textSpanForBD = TextSpan(
        text:
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB",
        style: effectiveStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: ui.TextDirection.rtl,
    );
    final textPainterForBg = TextPainter(
      text: textSpanForBD,
      textAlign: TextAlign.left,
      textDirection: ui.TextDirection.rtl,
    );
    textPainter.layout();
    textPainterForBg.layout();

    final uiSize = textPainter.size;
    final uiSizeForBg = textPainterForBg.size;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint()..color = backgroundColor;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, uiSizeForBg.width, uiSize.height), paint);

    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final img = await picture.toImage(
        (uiSizeForBg.width).toInt(), uiSize.height.toInt());

    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> createCombinationTextImage(
    String text, {
    TextStyle? style,
    Color backgroundColor = Colors.white,
  }) async {
    final TextStyle effectiveStyle = style ??
        const TextStyle(
            fontSize: 25,
            color: Colors.black,
            // fontWeight: ui.FontWeight.w600,
            // fontFamily: "Oswald",
            // letterSpacing: 2.0,
        );
    // if(text.length > 37) {
    //   text=
    // }
    final textSpan = TextSpan(text: text.trim(), style: effectiveStyle);
    final textSpanForBD = TextSpan(
        text:
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB",
        style: effectiveStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: ui.TextDirection.rtl,
    );
    final textPainterForBg = TextPainter(
      text: textSpanForBD,
      textAlign: TextAlign.left,
      textDirection: ui.TextDirection.rtl,
    );
    textPainter.layout();
    textPainterForBg.layout();

    final uiSize = textPainter.size;
    final uiSizeForBg = textPainterForBg.size;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint()..color = backgroundColor;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, uiSizeForBg.width, uiSize.height), paint);

    final yOffset = ((uiSizeForBg.height - uiSize.height) / 2)+5; // Calculate vertical center
    textPainter.paint(canvas, Offset(0, yOffset)); // Apply vertical centering

    final picture = recorder.endRecording();
    final img = await picture.toImage(
        uiSizeForBg.width.toInt(), uiSizeForBg.height.toInt()); // Use full background height

    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }



  String formatedPrint(String skuName, String qty, String amount) {
    List d = [9, 6, 10, 12];
    String formated = "";
    if (skuName.length > d[3]) {
      skuName = skuName + "\r\n" + spad("", d[3]);
    } else {
      skuName = spad(skuName, d[3]);
    }

    formated = skuName + spad(qty, d[1], 1) + spad(amount.toString(), d[3], 1);
    return formated;
  }

  String formatted2ColumnPrint(String key, String value) {
    String res = '';
    int dashLen = 32 - (key.length + value.length);
    res += key;
    for (int i = 0; i < dashLen; i++) {
      res += '-';
    }
    res += value;
    return res;
  }

  String spad(String a, int b, [int c = 0]) {
    String aString = a;
    if (a.length > b) {
      aString = a.toString().substring(0, b);
    }

    int z = b - aString.length;
    String s = "---------------------------";
    if (c != 0) {
      if (c == 1) {
        return s.substring(0, z) + aString;
      } else if (c == 2) {
        return s.substring(0, (z / 2).floor()) +
            aString +
            s.substring(0, (z / 2).ceil());
      }
    }
    return aString + s.substring(0, z);
  }

  configurePrinter(BlueThermalPrinter bluetooth) {
    try {} catch (e) {
      print("inside configurePrinter printercontroller catch block $e");
    }
  }

  int get12HourBy24Hour(int hour) {
    if (hour > 12) {
      hour = hour - 12;
    }
    return hour;
  }

  String getAMPMbyHour(int hour) {
    if (hour < 12) {
      return "AM";
    } else {
      if (hour == 24) {
        return "AM";
      } else {
        return "PM";
      }
    }
  }

  print48Title({required String title, required String data}) {
    int maxCapacity = 48 - 5; //5 for safe space
    int titleLength = title.length;
    int dataLength = data.length;
    if ((maxCapacity - (dataLength + titleLength)) > 0) {
      int totalSpaceCount = ((maxCapacity) - (dataLength + titleLength));
      String spacePrefix = "";

      for (int i = 0; i < totalSpaceCount; i++) {
        spacePrefix += " ";
      }
      data = spacePrefix + data;
    }
    return _bluetooth.printCustom("$title     $data", 1, 0);
  }

  String get48Title({required String title, required String data}) {
    int maxCapacity = 48 - 5; //5 for safe space
    int titleLength = title.length;
    int dataLength = data.length;
    if ((maxCapacity - (dataLength + titleLength)) > 0) {
      int totalSpaceCount = ((maxCapacity) - (dataLength + titleLength));
      String spacePrefix = "";

      for (int i = 0; i < totalSpaceCount; i++) {
        spacePrefix += "  ";
      }
      spacePrefix += " ";
      spacePrefix += " ";
      spacePrefix += " ";
      spacePrefix += " ";
      spacePrefix += " ";
      data = spacePrefix + data;
    }
    return "$title$data";
  }

  print64Title({required String leftData, required String rightData}) {
    int maxCapacity = 64; //5 for safe space
    int titleLength = leftData.length;
    int rightDataLength = rightData.length;
    if ((maxCapacity - (rightDataLength + titleLength)) > 0) {
      int totalSpaceCount = ((maxCapacity) - (rightDataLength + titleLength));
      String spacePrefix = "";

      for (int i = 0; i < totalSpaceCount; i++) {
        spacePrefix += " ";
      }
      rightData = spacePrefix + rightData;
    }
    return _bluetooth.printCustom("$leftData$rightData", 0, 0);
  }

  print64SkuInfo({
    required String title,
    required String qty,
    required String total,
    required String offer,
    required String payable,
  }) {
    int safeSpace = 2;
    int skuDedicatedDigit = 15; //22;
    int qtyDedicatedDigit = 12;
    int totalDedicatedDigit = 10;
    int offerDedicatedDigit = 9;
    int payableDedicatedDigit = 10;

    return _bluetooth.printCustom(
        "${title.padRight(skuDedicatedDigit)}${"".padRight(safeSpace)}${qty.padLeft(qtyDedicatedDigit)}${"".padRight(safeSpace)}${total.padLeft(totalDedicatedDigit)}${"".padRight(safeSpace)}${offer.padLeft(offerDedicatedDigit)}${"".padRight(safeSpace)}${payable.padLeft(payableDedicatedDigit)}",
        0,
        0);
  }

  void _generateTitleBar(Map<String, List<LoadSummaryDetails>> loadSummary) {
    int tripCount = loadSummary.length;

    int maxTripCount = 36;
    int individualTripSpace = ((maxTripCount)/tripCount).floor();

    _bluetooth.printCustom("------------------------------------------------", 1, 0);
    _bluetooth.printCustom(formatTrips(tripCount).padRight(maxTripCount)+formatTwoValues("Total", "Amount"), 0, 0);
  }

  print64SkuInfoForLoadSummary({
    required String title,
    required String qty,
    required String total,
    required String offer,
    required String payable,
  }) {
    int safeSpace = 2;
    int skuDedicatedDigit = 5;
    int qtyDedicatedDigit = 8;
    int totalDedicatedDigit = 10;
    int offerDedicatedDigit = 9;
    int payableDedicatedDigit = 10;

    _bluetooth.printCustom("${title.padRight(skuDedicatedDigit)}${"".padRight(safeSpace)}${qty.padLeft(qtyDedicatedDigit)}${"".padRight(safeSpace)}${total.padLeft(totalDedicatedDigit)}${"".padRight(safeSpace)}${offer.padLeft(offerDedicatedDigit)}${"".padRight(safeSpace)}${payable.padLeft(payableDedicatedDigit)}", 0, 0);
  }

  String _getSkuWiseRtySum(TripWiseMemoData sku) {
    num sale = sku.qtyPurchase.values.fold(0, (a, b) => a.floor() + b.floor());
    num fractional = sku.qtyPurchase.values.fold(0, (a, b) => _printMemoService.getFractionalPart(a) + _printMemoService.getFractionalPart(b));
    fractional = fractional * sku.formatedSku.packSizeCases;
    num offer = sku.qtyOffer.values.fold(0, (a, b) => a + b);
    String saleValue = sale.toString().nonZeroText;
    String offerValue = offer.toString().nonZeroText;
    if(offer != 0) {
      if(sale == 0) {
        if(fractional > 0) {
          return "0[${fractional.toString().nonZeroText}]($offerValue)";
        }
        return "0($offerValue)";
      }
      if(fractional > 0) {
        return "$saleValue[${fractional.toString().nonZeroText}]($offerValue)";
      }
      return "$saleValue($offerValue)";
    }

    if(fractional > 0) {
      return "$saleValue[${fractional.toString().nonZeroText}]";
    }
    return saleValue;
  }

  String formatTrips(int individualTripSpace) {
    List<String> trips = List.generate(individualTripSpace, (index) => "Trip ${index + 1}");

    // Calculate available spaces to distribute
    int totalChars = trips.fold(0, (sum, trip) => sum + trip.length);
    int totalSpaces = 36 - totalChars; // Remaining space for padding
    int spacePerTrip = (individualTripSpace > 0) ? totalSpaces ~/ individualTripSpace : 0;

    String spaceString = " " * spacePerTrip; // Equal space after each trip

    // Add spaces after each trip label
    List<String> spacedTrips = trips.map((trip) => trip + spaceString).toList();

    // Join the trips and trim excess spaces to fit within 36 characters
    return spacedTrips.join("").trimRight().padRight(36);
  }

  String formatSkuSales(int individualTripSpace, TripWiseMemoData sku) {
    List<String> trips = List.generate(individualTripSpace, (index) {
      num sale =  sku.qtyPurchase.containsKey(index) ? (sku.qtyPurchase[index]??0) : 0;
      num fractionPart =  sku.qtyPurchase.containsKey(index) ? (_printMemoService.getFractionalPart((sku.qtyPurchase[index]??0))*sku.formatedSku.packSizeCases) : 0;
      num offer =  sku.qtyOffer.containsKey(index) ? (sku.qtyOffer[index]??0) : 0;
      if(sale ==0 && offer == 0) {
        return "";
      } else {
        String finalText = "";
        if(sale > 0) {
          finalText += sale.floor().toString().nonZeroText;
        }
        if(fractionPart > 0) {
          finalText += "[${fractionPart.toString().nonZeroText}]";
        }
        if(offer > 0) {
          finalText += "(${offer.toString().nonZeroText})";
        }
        return finalText;
      }
    });

    // Calculate available spaces to distribute
    int totalChars = trips.fold(0, (sum, trip) => sum + trip.length);
    int totalSpaces = 36 - totalChars; // Remaining space for padding
    int spacePerTrip = (individualTripSpace > 0) ? totalSpaces ~/ individualTripSpace : 0;

    String spaceString = " " * spacePerTrip;

    List<String> spacedTrips = trips.map((trip) => trip + spaceString).toList();

    // Join the trips and trim excess spaces to fit within 36 characters
    return spacedTrips.join("").trimRight().padRight(36);
  }

  String formatTwoValues(String value1, String value2) {
    String formattedValue1 = value1.toString().padRight(14); // 14 chars
    String formattedValue2 = value2.toString().padLeft(14); // 14 chars

    return formattedValue1 + formattedValue2;
  }

  String formatTwoValuesNum(num sale, num offer) {
    String saleValue = sale.toString().nonZeroText.padRight(14); // 14 chars
    String offerValue = offer.toString().nonZeroText.padRight(14); // 14 chars
    if(offer != 0) {
      return "$saleValue($offerValue)";
    }

    return saleValue;
  }

  num getTripDividerCount({int max=32, required int individualTripSpace}) {
    return 0;
  }

  String formatTripWiseMemoData(TripWiseMemoData data) {
    List<String> formattedList = data.qtyPurchase.keys.map((key) {
      num purchase = data.qtyPurchase[key] ?? 0;
      num offer = data.qtyOffer[key] ?? 0;
      if(offer == 0) {
        return purchase.toString().nonZeroText;
      }
      return "${purchase.toString().nonZeroText}(${offer.toString().nonZeroText})";
    }).toList();

    return formattedList.join(", ");
  }



  void _generateSkuAndSales(Map<String, List<LoadSummaryDetails>> loadSummary, TripWiseMemoData sku) {
    int tripCount = loadSummary.length;

    int maxTripCount = 36;

    _bluetooth.printCustom(formatSkuSales(tripCount, sku).padRight(maxTripCount)+formatTwoValues(_getSkuWiseRtySum(sku), "${sku.total-sku.offer}".nonZeroText), 0, 0);
  }

  void _getTotalRow(List<TripWiseMemoData> skusList, Map<String, List<LoadSummaryDetails>> loadSummary) {
    int tripCount = loadSummary.length;
    int maxTripCount = 36;

    num totalQtySale = 0;
    num totalQtyFractional = 0;
    num totalQtyOffer = 0;
    num totalTotal = 0;
    num totalOffer = 0;
    for(TripWiseMemoData sku in skusList) {
      totalQtySale += sku.qtyPurchase.values.fold(0, (a, b) => a.floor() + b.floor());
      num fractional = (sku.qtyPurchase.values.fold(0, (a, b) => _printMemoService.getFractionalPart(a) + _printMemoService.getFractionalPart(b)));
      totalQtyFractional += fractional * sku.formatedSku.packSizeCases;
      totalQtyOffer += sku.qtyOffer.values.fold(0, (a, b) => a + b);
      totalTotal += sku.total;
      totalOffer += sku.offer;
    }
    Map<num, num> tripWiseQtyTotal = {};
    Map<num, num> tripWiseQtyTotalFractional = {};
    Map<num, num> tripWiseQtyOffer = {};
    for(int a=0; a!=tripCount; a++) {
      num totalQtySale = 0;
      num totalQtySaleFractional = 0;
      num totalQtyOffer = 0;
      for(TripWiseMemoData sku in skusList) {
        totalQtySale += (sku.qtyPurchase[a] ?? 0).floor();
        totalQtySaleFractional += (_printMemoService.getFractionalPart(sku.qtyPurchase[a] ?? 0) * sku.formatedSku.packSizeCases);
        totalQtyOffer += sku.qtyOffer[a] ?? 0;
      }
      tripWiseQtyTotal[a] = totalQtySale;
      tripWiseQtyTotalFractional[a] = totalQtySaleFractional;
      tripWiseQtyOffer[a] = totalQtyOffer;
    }

    _bluetooth.printCustom(formatTotalSkuSales(tripCount, tripWiseQtyTotal, tripWiseQtyTotalFractional, tripWiseQtyOffer).padRight(maxTripCount)+formatTwoValues(getFormatedTotalFroLoadSummary(totalQtySale, totalQtyFractional, totalQtyOffer), "${totalTotal-totalOffer}".nonZeroText), 0, 0);
  }

  String formatTotalSkuSales(int individualTripSpace, Map<num, num> qtySale, Map<num, num> qtySaleFractional, Map<num, num> qtyOffer) {
    List<String> trips = List.generate(individualTripSpace, (index) {
      num sale =  qtySale.containsKey(index) ? (qtySale[index]??0).floor() : 0;
      num saleFractional =  qtySaleFractional.containsKey(index) ? (qtySaleFractional[index]??0).floor() : 0;
      num offer =  qtyOffer.containsKey(index) ? (qtyOffer[index]??0) : 0;
      if(sale ==0 && offer == 0 && saleFractional == 0) {
        return "";
      } else {
        String finalText = "";
        if(sale > 0) {
          finalText += sale.toString().nonZeroText;
        } else {
          finalText += "0";
        }
        if(saleFractional > 0) {
          finalText += "[${saleFractional.toString().nonZeroText}]";
        }
        if(offer > 0) {
          finalText += "(${offer.toString().nonZeroText})";
        }
        return finalText;
      }
    });

    int totalChars = trips.fold(0, (sum, trip) => sum + trip.length);
    int totalSpaces = 36 - totalChars;
    int spacePerTrip = (individualTripSpace > 0) ? totalSpaces ~/ individualTripSpace : 0;

    String spaceString = " " * spacePerTrip;
    List<String> spacedTrips = trips.map((trip) => trip + spaceString).toList();

    // Join the trips and trim excess spaces to fit within 36 characters
    return spacedTrips.join("").trimRight().padRight(36);
  }

  String getFormatedTotalFroLoadSummary(num totalQtySale, num totalQtyFractional, num totalQtyOffer) {
    String finalOutput = "";
    finalOutput += totalQtySale.toString().nonZeroText;
    if(totalQtyFractional != 0) {
      finalOutput += "[${totalQtyFractional.toString().nonZeroText}]";
    }
    if(totalQtyOffer != 0) {
      finalOutput += "(${totalQtyOffer.toString().nonZeroText})";
    }
    return finalOutput;
  }
}
