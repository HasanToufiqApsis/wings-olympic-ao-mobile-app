import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/stock_validation_model.dart';
import '../providers/stock_validation_notifier.dart';

final stockValidationProvider = StateNotifierProvider.autoDispose<
    StockValidationNotifier, AsyncValue<StockValidationResponseModel>>(
  (ref) => StockValidationNotifier(ref),
);