import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/module.dart';
import '../../models/products_details_model.dart';
import '../../models/qc_config_model.dart';
import '../../services/product_category_services.dart';
import '../../services/sales_service.dart';
import '../../services/sync_read_service.dart';

class QCSKUNotifier extends StateNotifier<AsyncValue<List<ProductDetailsModel>>>{
  QCSKUNotifier():super(AsyncLoading()){
    init();
  }

  List<ProductDetailsModel> skuList = [];

  init()async{
    // List<List<ProductDetailsModel>> skuList = [];
    List<Module> moduleList = await SyncReadService().getModuleModelList();
    QcConfigurationModel configuration = await SalesService().getQcConfigurations();
    for (Module module in moduleList) {
      if (configuration.availableModules.contains(module.id)) {
        List<ProductDetailsModel> productDetailsModelList = await ProductCategoryServices().getProductDetailsList(module);
        skuList.addAll(productDetailsModelList);
      }
    }
    state = AsyncData([...skuList]);
  }

  searchQC(String keyWord){
    List<ProductDetailsModel> newSkuList = [];
    if(keyWord.isNotEmpty){
      for(ProductDetailsModel sku in skuList){
        if(sku.shortName.toLowerCase().contains(keyWord.toLowerCase())){
          newSkuList.add(sku);
        }
      }
    }
    else {
      newSkuList = [...skuList];
      // state = AsyncData([...skuList]);
    }

    state = AsyncData([...newSkuList]);
  }

}