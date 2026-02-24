import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/leave_management/model/selected_vehicle_with_tada.dart';
import '../../screens/leave_management/model/ta_da_vehicle_model.dart';
import '../../screens/olympic_tada/model/extra_ta_da_model.dart';
import '../../screens/olympic_tada/model/selected_vehicle_with_tada_olympic.dart';

class OlympicTaDaNotifier extends StateNotifier<List<SelectedVehicleWithTaDaOlympic>> {

  OlympicTaDaNotifier(this.ref) : super([SelectedVehicleWithTaDaOlympic(textEditingController: TextEditingController())]) {
    init();
  }

  final Ref ref;

  init() async {
    state = [SelectedVehicleWithTaDaOlympic(textEditingController: TextEditingController())];
  }

  addNew() {
    state = [...state]..add(SelectedVehicleWithTaDaOlympic(textEditingController: TextEditingController()));
  }

  addAnother({required SelectedVehicleWithTaDaOlympic taDa}) {
    state = [...state]..add(taDa);
  }

  updateTaDaType({required SelectedVehicleWithTaDaOlympic taDa, required int index, required ExtraTaDaType taDaItem}) {
    final v = state[index];
    v.selectedTaDa = taDaItem;
    if((taDaItem.isTextInput??false)) {
      v.textEditingController?.text = '';
    } else {
      v.textEditingController?.text = taDaItem.amount.toString();
    }
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
