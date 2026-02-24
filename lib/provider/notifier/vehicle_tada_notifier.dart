import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/leave_management/model/selected_vehicle_with_tada.dart';
import '../../screens/leave_management/model/ta_da_vehicle_model.dart';

class VehicleTaDaNotifier extends StateNotifier<List<SelectedVehicleWithTaDa>> {

  VehicleTaDaNotifier(this.ref) : super([SelectedVehicleWithTaDa(textEditingController: TextEditingController())]) {
    init();
  }

  final Ref ref;

  init() async {
    state = [SelectedVehicleWithTaDa(textEditingController: TextEditingController())];
  }

  addNew() {
    state = [...state]..add(SelectedVehicleWithTaDa(textEditingController: TextEditingController()));
  }

  addAnother({required SelectedVehicleWithTaDa taDa}) {
    state = [...state]..add(taDa);
  }

  updateTaDaType({required SelectedVehicleWithTaDa taDa, required int index, required TaDaVehicleModel taDaItem}) {
    final v = state[index];
    v.selectedTaDa = taDaItem;
    final currentList = state;
    currentList[index] = v;
    state = [...currentList];
  }

  removeTaDa({required int index}) {
    final currentList = state;
    currentList.removeAt(index);

    state = [...currentList];

  }
}

class OtherVehicleTaDaNotifier extends StateNotifier<List<SelectedVehicleWithTaDa>> {

  OtherVehicleTaDaNotifier(this.ref) : super([SelectedVehicleWithTaDa(textEditingController: TextEditingController())]) {
    init();
  }

  final Ref ref;

  init() async {
    state = [SelectedVehicleWithTaDa(textEditingController: TextEditingController())];
  }

  addNew() {
    state = [...state]..add(SelectedVehicleWithTaDa(textEditingController: TextEditingController()));
  }

  updateTaDaType({required SelectedVehicleWithTaDa taDa, required int index, required TaDaVehicleModel taDaItem}) {
    final v = state[index];
    v.selectedTaDa = taDaItem;
    final currentList = state;
    currentList[index] = v;
    state = [...currentList];
  }

  removeTaDa({required int index}) {
    final currentList = state;
    currentList.removeAt(index);

    state = [...currentList];

  }
}
