import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/outlet_model.dart';
import '../../models/retailers_mdoel.dart';
import '../../services/asset_management_service.dart';
import '../../services/outlet_services.dart';
import '../global_provider.dart';

class RequisitionOutletListNotifier extends StateNotifier<AsyncValue<List<RetailersModel>>>{
  List<RetailersModel> outletList = [];
  List<String> alphabetList =[];
  RequisitionOutletListNotifier(this.ref) : super(const AsyncLoading()){
    init();
  }
  final Ref ref;
  init()async{
    outletList = await AssetManagementService().getSoRetailerListProvider();
    setInitialAlphabetList();
    state = AsyncData(outletList);
  }

  setInitialAlphabetList(){
    Set<String> alphabets = {};

    if(outletList.isNotEmpty){
      for(RetailersModel o in outletList){
        alphabets.add(o.outletName.trim()[0]);
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
      List<RetailersModel> filteredOutletList = [];
      for(RetailersModel outletModel in outletList){
        if(outletModel.outletName.toLowerCase().contains(key.toLowerCase())){
          filteredOutletList.add(outletModel);
        }
      }
      state = AsyncData([...filteredOutletList]);
    }else{
      state = AsyncData([...outletList]);
    }

  }

  searchByFirstLetter(String first){
    List<RetailersModel> filteredOutlets = [];
    if(first == "All"){
      filteredOutlets = outletList;
    }else{
      filteredOutlets = outletList.where((f) => f.outletName.startsWith(first)).toList();
    }
    ref.read(selectedRetailerProvider.notifier).state = null;
    ref.read(selectedAlphabetProvider.notifier).state = first;
    state= AsyncData(filteredOutlets);
  }
}