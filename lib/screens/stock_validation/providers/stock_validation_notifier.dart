import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/stock_validation_model.dart';
import '../repository/stock_validation_repository.dart';

class StockValidationNotifier
    extends StateNotifier<AsyncValue<StockValidationResponseModel>> {
  final Ref ref;
  final _repo = StockValidationRepository();

  StockValidationNotifier(this.ref) : super(const AsyncValue.loading()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      state = const AsyncValue.loading();
      final result = await _repo.getQcVerificationData();
      if (result.data != null && result.data['data'] != null) {
        final parsed =
            StockValidationResponseModel.fromJson(result.data['data']);
        state = AsyncValue.data(parsed);
      } else {
        state = AsyncValue.error(
          result.errorMessage ?? 'Failed to fetch data',
          StackTrace.current,
        );
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> refresh() => _fetchData();
}