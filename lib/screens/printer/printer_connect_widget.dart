import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../../constants/enum.dart';
import '../../provider/global_provider.dart';
import 'controllers/printer_controller.dart';

// class PrinterConnectWidget extends ConsumerStatefulWidget {
//   const PrinterConnectWidget({Key? key}) : super(key: key);
//
//   @override
//   _PrinterConnectWidgetState createState() => _PrinterConnectWidgetState();
// }

class PrinterConnectWidget extends ConsumerStatefulWidget {
  const PrinterConnectWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<PrinterConnectWidget> createState() => _PrinterConnectWidgetState();
}

class _PrinterConnectWidgetState extends ConsumerState<PrinterConnectWidget> {

  @override
  void initState() {
    // PrinterController(ref: ref, context: context).configureBluetoothPrinter(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      elevation: 20,
      backgroundColor: primaryBlue,
      onPressed: (){
        PrinterController(ref: ref, context: context).configureBluetoothPrinter();
      },
      child: Consumer(
        builder: (context, ref, _){
          PrinterStatus printerConnected = ref.watch(printerConnectedProvider);
          // bool printerConnected = ref.watch(isPrinterConnectedProvider);
          if(printerConnected == PrinterStatus.connected){
            return const Icon(Icons.print, color: Colors.white,);
          }
          else if (printerConnected == PrinterStatus.disconnected){
            return const Icon(Icons.print_disabled, color: Colors.white);
          }
          else {
            return Stack(
              children: [
                Center(child: Icon(Icons.print, color: grey,)),
                Center(child: CircularProgressIndicator(strokeWidth: 2.sp,)),
              ],
            );
          }
          // return printerConnected?
          // Icon(Icons.print, color: green,)
          //     :
          // const Icon(Icons.print_disabled, color: Colors.red);
        },
      )
    );
  }

  void returnFloatingActionButton({required int elevation, required backgroundColor, required Null Function() onPressed, required child}) {}
}
