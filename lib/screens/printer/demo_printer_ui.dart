import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../reusable_widgets/language_textbox.dart';
import 'controllers/printer_controller.dart';


class DemoPrinter extends ConsumerStatefulWidget {
  const DemoPrinter({Key? key}) : super(key: key);
  static const routeName = "/print";
  @override
  _DemoPrinterState createState() => _DemoPrinterState();
}

class _DemoPrinterState extends ConsumerState<DemoPrinter> {
  late PrinterController printerController;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    printerController = PrinterController(context: context, ref: ref);
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected ?? false;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {

    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: LangText('Blue Thermal Printer'), //Blue Thermal Printer
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    LangText(
                      'Device:', // Device
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (value) =>
                            setState(() => _device = value as BluetoothDevice),
                        value: _device,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                      onPressed: () {
                        initPlatformState();
                      },
                      child: LangText(
                        'Refresh', //Refresh
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _connected ? Colors.red : Colors.green),
                      onPressed: _connected ? _disconnect : _connect,
                      child: LangText(
                        _connected
                            ? 'Disconnect'
                            : 'Connect', // Disconnected // Connect
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    onPressed: () {
                      bluetooth.isConnected.then((isConnected) {
                        if (isConnected == true) {
                          bluetooth.printNewLine();
                          bluetooth.printCustom("Lubna Traders", 1, 0);
                          bluetooth.printCustom("Madaripur", 1, 0);
                          bluetooth.printCustom("4/6/2021 17.49", 1, 0);
                          bluetooth.printCustom("SR: Robiul (101A)", 1, 0);
                          bluetooth.printCustom("Runa Store (P)", 1, 0);
                          bluetooth.printNewLine();
                          bluetooth.printCustom(
                              "--------------------------------", 1, 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "B&H SW 20HL", "20", "269.9"),
                              1,
                              0);
                          // bluetooth.print3Column("B&H SW 20HL", "20", "269.9", 0);
                          // bluetooth.printCustom( printerController.formatedPrint("B&H SW 20HL", 20, 269.9),0,0);
                          // bluetooth.print3Column("JPGL 20HL", "20", "203.9", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "JPGL 20HL", "20", "203.9"),
                              1,
                              0);
                          // bluetooth.print3Column("CAP 20HL", "20", "269.9", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "CAP 20HL", "20", "269.9"),
                              1,
                              0);

                          // bluetooth.print3Column("DB 20HL", "20", "77.9", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "DB 20HL", "20", "77.9"),
                              1,
                              0);
                          // bluetooth.print3Column("DB 10HL", "1000", "3895", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "DB 10HL", "1000", "3895"),
                              1,
                              0);
                          // bluetooth.print3Column("B&H SF 20HL", "1000", "13495", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "B&H SF 20HL", "1000", "13495"),
                              1,
                              0);
                          // bluetooth.print3Column("B&H SF 12HL", "12", "161.94", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "B&H SF 12HL", "12", "161.94"),
                              1,
                              0);
                          // bluetooth.print3Column("JPGL 12HL", "12", "122.34", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "JPGL 12HL", "12", "122.34"),
                              1,
                              0);
                          // bluetooth.print3Column("JP SW 20HL", "20", "203.9", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "JP SW 20HL", "20", "203.9"),
                              1,
                              0);
                          // bluetooth.print3Column("HWD 20HL", "1000", "3895", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "HWD 20HL", "1000", "3895"),
                              1,
                              0);
                          // bluetooth.print3Column("HWD 10HL", "10", "38.95", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "HWD 10HL", "10", "38.95"),
                              1,
                              0);
                          // bluetooth.print3Column("RG 20HL", "20", "83.9", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "RG 20HL", "20", "83.9"),
                              1,
                              0);
                          // bluetooth.print3Column("RG 10HL", "1000", "4195", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "RG 10HL", "1000", "4195"),
                              1,
                              0);
                          // bluetooth.print3Column("RN 20HL", "20", "83.9", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "RN 20HL", "20", "83.9"),
                              1,
                              0);
                          // bluetooth.print3Column("JPGL HE 20HL", "1000", "10195", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "JPGL HE 20HL", "1000", "10195"),
                              1,
                              0);
                          // bluetooth.print3Column("SRF 20HL", "20", "125.9", 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "SRF 20HL", "20", "125.9"),
                              1,
                              0);
                          // bluetooth.print3Column("SRN 10HL", "10", "62.95", 0);
                          bluetooth.printNewLine();
                          bluetooth.printCustom(
                              "--------------------------------", 1, 0);
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "TOTAL", "5204", "37314.38"),
                              1,
                              0);
                          bluetooth.printNewLine();
                          // bluetooth.printNewLine();
                          bluetooth.printCustom(
                              printerController.formatedPrint(
                                  "QC Settlement", "", "110.38"),
                              1,
                              0);
                          // bluetooth.print3Column("TOTAL", "5204", "37314.38", 1);
                          bluetooth.printNewLine();
                          bluetooth.printNewLine();
                          bluetooth.paperCut();
                        }
                      });
                    },
                    child: LangText('Print Examine', // PRINT TEST
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: LangText('None'), // NONE
      ));
    } else {
      for (var device in _devices) {
        items.add(DropdownMenuItem(
          child: LangText(device.name ?? "Not Found"), // Not Available
          value: device,
        ));
      }
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('কোনো ডিভাইস নির্বাচন করা হয়নি।'); // No device selected.
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }

    print("bluetooth connected");
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: LangText(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}
