import 'package:flutter/material.dart';

import '../../leave_management/model/ta_da_vehicle_model.dart';

class OlympicTaDaEntry {
  OlympicTaDaEntry({
    String? identity,
    this.selectedVehicle,
    TextEditingController? fromController,
    TextEditingController? toController,
    TextEditingController? kmController,
    TextEditingController? amountController,
    TextEditingController? remarksController,
  }) : identity = identity ?? DateTime.now().microsecondsSinceEpoch.toString(),
       fromController = fromController ?? TextEditingController(),
       toController = toController ?? TextEditingController(),
       kmController = kmController ?? TextEditingController(),
       amountController = amountController ?? TextEditingController(),
       remarksController = remarksController ?? TextEditingController();

  final String identity;
  TaDaVehicleModel? selectedVehicle;
  final TextEditingController fromController;
  final TextEditingController toController;
  final TextEditingController kmController;
  final TextEditingController amountController;
  final TextEditingController remarksController;

  factory OlympicTaDaEntry.fromJson(
    Map<String, dynamic> json,
    List<TaDaVehicleModel> vehicles,
  ) {
    final vehicleId = int.tryParse(json['vehicle_id']?.toString() ?? '');
    TaDaVehicleModel? selectedVehicle;
    if (vehicleId != null) {
      for (final vehicle in vehicles) {
        if (vehicle.id == vehicleId) {
          selectedVehicle = vehicle;
          break;
        }
      }
    }

    return OlympicTaDaEntry(
      identity: json['identity']?.toString(),
      selectedVehicle: selectedVehicle,
      fromController: TextEditingController(
        text: json['from']?.toString() ?? '',
      ),
      toController: TextEditingController(text: json['to']?.toString() ?? ''),
      kmController: TextEditingController(text: json['km']?.toString() ?? ''),
      amountController: TextEditingController(
        text: json['amount']?.toString() ?? '',
      ),
      remarksController: TextEditingController(
        text: json['remarks']?.toString() ?? '',
      ),
    );
  }

  bool get isEmpty {
    return selectedVehicle == null &&
        fromController.text.trim().isEmpty &&
        toController.text.trim().isEmpty &&
        kmController.text.trim().isEmpty &&
        amountController.text.trim().isEmpty &&
        remarksController.text.trim().isEmpty;
  }

  bool get isComplete {
    return selectedVehicle != null &&
        fromController.text.trim().isNotEmpty &&
        toController.text.trim().isNotEmpty &&
        amount > 0;
  }

  double get amount => double.tryParse(amountController.text.trim()) ?? 0;

  double? get km {
    final value = kmController.text.trim();
    if (value.isEmpty) return null;
    return double.tryParse(value);
  }

  Map<String, dynamic> toDraftJson() {
    return <String, dynamic>{
      'identity': identity,
      'vehicle_id': selectedVehicle?.id,
      'vehicle_slug': selectedVehicle?.slug,
      'from': fromController.text.trim(),
      'to': toController.text.trim(),
      'km': kmController.text.trim(),
      'amount': amountController.text.trim(),
      'remarks': remarksController.text.trim(),
    };
  }

  Map<String, dynamic> toTravelInfoJson() {
    return <String, dynamic>{
      'from_location': fromController.text.trim(),
      'to_location': toController.text.trim(),
      'km': km ?? 0,
      'category': selectedVehicle?.id ?? 0,
      'amount': amount,
      'remark': remarksController.text.trim(),
    };
  }

  void dispose() {
    fromController.dispose();
    toController.dispose();
    kmController.dispose();
    amountController.dispose();
    remarksController.dispose();
  }
}
