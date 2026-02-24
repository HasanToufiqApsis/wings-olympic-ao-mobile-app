import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/sync_global.dart';
import '../../../provider/global_provider.dart';
import '../../../services/Image_service.dart';
import '../../../services/sync_service.dart';

class StockCheckState {
  final File? beforeImage;
  final File? afterImage;
  final bool canRetakeBefore;
  final bool canRetakeAfter;

  StockCheckState({
    this.beforeImage,
    this.afterImage,
    this.canRetakeBefore = true,
    this.canRetakeAfter = true,
  });

  StockCheckState copyWith({
    File? beforeImage,
    File? afterImage,
    bool? canRetakeBefore,
    bool? canRetakeAfter,
  }) {
    return StockCheckState(
      beforeImage: beforeImage ?? this.beforeImage,
      afterImage: afterImage ?? this.afterImage,
      canRetakeBefore: canRetakeBefore ?? this.canRetakeBefore,
      canRetakeAfter: canRetakeAfter ?? this.canRetakeAfter,
    );
  }
}

class StockCheckController extends StateNotifier<StockCheckState> {
  final Ref ref;
  StockCheckController(this.ref) : super(StockCheckState()) {
    _loadConfigurations();
  }

  Future<void> _loadConfigurations() async {
    await SyncService().checkSyncVariable();
    bool retakeBefore = true;
    bool retakeAfter = true;
    File? beforeImage;
    File? afterImage;
    final outlet = ref.watch(selectedRetailerProvider);
    if(outlet!=null) {
      if(syncObj.containsKey(stockCheckDaya)) {
        if (syncObj[stockCheckDaya].containsKey(outlet.id.toString())) {
          if(syncObj[stockCheckDaya][outlet.id.toString()].containsKey('before')) {
            beforeImage = File.fromUri(Uri(path: syncObj[stockCheckDaya][outlet.id.toString()]['before']['image']));
          }
          if(syncObj[stockCheckDaya][outlet.id.toString()].containsKey('after')) {
            afterImage = File.fromUri(Uri(path: syncObj[stockCheckDaya][outlet.id.toString()]['after']['image']));
          }
        }
      }
    }

    if (syncObj.containsKey('stock_check_image_retake')) {
      retakeBefore = syncObj['stock_check_image_retake'] == 1;
      retakeAfter = syncObj['stock_check_image_retake'] == 1;
    }


    state = state.copyWith(
      canRetakeBefore: retakeBefore,
      canRetakeAfter: retakeAfter,
      afterImage: afterImage,
      beforeImage: beforeImage,
    );
  }
}