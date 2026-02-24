import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/location_category_models.dart';
import '../services/retailer_selection_service.dart';

final retailerSelectionConfigProvider = FutureProvider.autoDispose((ref) async => RetailerSelectionService().getRetailerSelectionConfig());
final selectedRoutesProvider = StateProvider.autoDispose<SectionModel?>((ref) => null);