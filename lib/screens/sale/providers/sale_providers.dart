import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/models/module.dart';
import 'package:wings_olympic_sr/models/products_details_model.dart';
import 'package:wings_olympic_sr/models/sales/sku_classification.dart';
import 'package:wings_olympic_sr/provider/global_provider.dart';
import 'package:wings_olympic_sr/screens/sale/model/product_view.dart';
import 'package:wings_olympic_sr/services/product_category_services.dart';
import 'package:wings_olympic_sr/services/sync_read_service.dart';

final skuClassificationsProvider =
    Provider.autoDispose((ref) => SyncReadService().getSkuClassifications());

final selectedClassificationProvider = StateProvider.autoDispose<SkuClassification?>((ref) => null);

final productViewTypeProvider = StateProvider((ref) => ViewComplexity.complex);

final skuListGroupByClassificationProvider = FutureProvider.autoDispose.family<Map<String, List<ProductDetailsModel>>, Module>((ref, module) async {
    return await ProductCategoryServices().getProductDetailsGroupByClassification(module);
});

final skuListGroupByClassificationProviderForDelivery = FutureProvider.autoDispose.family<Map<String, List<ProductDetailsModel>>, Module>((ref, module) async {
    final retailer = ref.read(selectedRetailerProvider);
    if (retailer == null) return {};
    return await ProductCategoryServices().getProductDetailsGroupByClassificationForDelivery(module, retailer);
});
