import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/dashboard_btn_names.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../outlet_informations/controller/outlet_controller.dart';
import 'delivery_ui.dart';
import 'multi_select_delivery_ui.dart';

class DeliverySelectionUI extends ConsumerStatefulWidget {
  const DeliverySelectionUI({Key? key}) : super(key: key);
  static const routeName = "/delivery_selection_ui";

  @override
  ConsumerState<DeliverySelectionUI> createState() => _DeliverySelectionUIState();
}

class _DeliverySelectionUIState extends ConsumerState<DeliverySelectionUI> {
  final _appBarTitle = DashboardBtnNames.delivery;
  late final Alerts _alerts;
  late final OutletController _outletController;

  @override
  void initState() {
    super.initState();
    _alerts = Alerts(context: context);
    _outletController = OutletController(context: context, ref: ref);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkDeliveryStatusOnLocal();
    });
  }

  Future<void> _checkDeliveryStatusOnLocal() async {
    _outletController.handleForceOutletSyncAndRedirectToDelivery();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset("", ),
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Hero(tag: DashboardBtnNames.getImageHeroTag(_appBarTitle),child: Image.asset("assets/delivery.png", height: 28, width: 28,)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: _appBarTitle,
                    child: Material(
                      color: Colors.transparent,
                      child: LangText(
                        _appBarTitle,
                        style: TextStyle(color: primaryGrey, fontSize: mediumFontSize, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 3.w),
            height: 7.h,
            decoration: BoxDecoration(
                color: greenOlive.withOpacity(0.1),
                shape: BoxShape.circle
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                      navigatorKey.currentState?.pop();
                    },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _alerts.customDialog(
                      message: 'You may have unsynced outlets. Please sync the outlet list if you want to make delivery at those outlets!',
                      button1: 'Yes',
                      button2: 'No',
                      twoButtons: true,
                      onTap1: () {
                        navigatorKey.currentState?.pop();
                        ref.refresh(selectedRetailerProvider);
                        ref.refresh(deliveryOutletListProvider);
                        ref.refresh(outletSaleStatusProvider);
                        _outletController.handleOutletSyncAndRedirectToDelivery(true);

                        // navigatorKey.currentState
                        //     ?.popAndPushNamed(DeliverySelectionUI.routeName);
                      },
                      onTap2: () {
                        Navigator.pop(context);
                      });
                },
                icon: Image.asset(
                  'assets/refresh.png',
                  height: 20,
                  width: 20,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 10,
            )
          ],
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: primaryGradient,
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
            // indicator: BoxDecoration(
            //   borderRadius: BorderRadius.circular(5.sp),
            //   gradient: const LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //       primary,
            //       primaryBlue,
            //     ],
            //   ),
            // ),
            indicatorColor: Theme.of(context).scaffoldBackgroundColor,
            indicatorWeight: 7,
            tabs: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Tab(
                  child: LangText("Single Delivery"),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Tab(
                  child: LangText("Bulk Delivery"),
                ),
              )
            ],
          ),
        ),
        // body: Container(),
        body: const TabBarView(
          children: [DeliveryUI(), MultiSelectDeliveryUI()],
        ),
      ),
    );
  }
}
