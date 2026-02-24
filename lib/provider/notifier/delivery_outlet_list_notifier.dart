import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/outlet_model.dart';
import '../../services/outlet_services.dart';
import '../global_provider.dart';

class DeliveryOutletListNotifier extends StateNotifier<AsyncValue<List<OutletModel>>>{
  List<OutletModel> outletList = [];
  List<String> alphabetList =[];
  DeliveryOutletListNotifier(this.ref) : super(const AsyncLoading()){
    init();
  }
  final Ref ref;
  init()async{
    outletList = await OutletServices().getDeliveryOutletList();
    setInitialAlphabetList();
    state = AsyncData(outletList);
  }

  setInitialAlphabetList(){
    Set<String> alphabets = {};

    if(outletList.isNotEmpty){
      for(OutletModel o in outletList){
        alphabets.add(o.name.trim()[0]);
      }
    }
    alphabetList.addAll(alphabets);
    if (alphabetList.isNotEmpty) {
      alphabetList.sort((a, b) => a.compareTo(b));
    }
    try{
      alphabetList.insert(0, "All");
      ref.read(alphabetListProvider.notifier).state = alphabetList;
    }catch(e){}

  }


  searchByKey(String key){
    if(key.isNotEmpty){
      List<OutletModel> filteredOutletList = [];
      for(OutletModel outletModel in outletList){
        if(outletModel.name.toLowerCase().contains(key.toLowerCase())){
          filteredOutletList.add(outletModel);
        }
      }
      state = AsyncData([...filteredOutletList]);
    }else{
      state = AsyncData([...outletList]);
    }

  }

  searchByFirstLetter(String first){
    List<OutletModel> filteredOutlets = [];
    if(first == "All"){
      filteredOutlets = outletList;
    }else{
      filteredOutlets = outletList.where((f) => f.name.startsWith(first)).toList();
    }
    ref.read(selectedRetailerProvider.notifier).state = null;
    ref.read(selectedAlphabetProvider.notifier).state = first;
    state= AsyncData(filteredOutlets);
  }
}