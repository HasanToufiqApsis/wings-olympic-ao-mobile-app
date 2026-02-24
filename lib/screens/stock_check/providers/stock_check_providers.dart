
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/screens/stock_check/providers/stock_check_notifier.dart';

final stockCheckProvider = StateNotifierProvider.autoDispose<StockCheckController, StockCheckState>((ref) {
  return StockCheckController(ref);
});