import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/date_extension.dart';
import 'dart:math' as math;

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/pjp_plan_details.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/geo_location_service.dart';

class PjpPlanItemWidget extends StatefulWidget {
  final int index;
  final PJPPlanDetails data;
  final Function()? onTap;

  const PjpPlanItemWidget({
    super.key,
    required this.index,
    required this.data,
    required this.onTap,
  });

  @override
  State<PjpPlanItemWidget> createState() => _PjpPlanItemWidgetState();
}

class _PjpPlanItemWidgetState extends State<PjpPlanItemWidget>
    with TickerProviderStateMixin {
  Animation<double>? animation, animationView;

  AnimationController? controller;

  bool expand = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = Tween(begin: 0.0, end: 180.0).animate(controller!);
    animationView = CurvedAnimation(parent: controller!, curve: Curves.linear);
    controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: widget.data.status == PjpStatusType.waiting
                    ? Colors.green.shade100
                    : widget.data.status == PjpStatusType.todayWaiting
                        ? Colors.transparent
                        : widget.data.status == PjpStatusType.missed
                            ? Colors.red
                            : widget.data.status == PjpStatusType.done
                                ? primary
                                : Colors.white,
              ),
              padding: const EdgeInsets.all(4),
              child: widget.data.status == PjpStatusType.todayWaiting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: SpinKitDoubleBounce(
                          color: primary,
                          size: 18.0,
                        ),
                      ),
                    )
                  : Icon(
                      widget.data.status == PjpStatusType.waiting
                          ? Icons.hourglass_top_rounded
                          : widget.data.status == PjpStatusType.todayWaiting
                              ? Icons.watch_later_outlined
                              : widget.data.status == PjpStatusType.missed
                                  ? Icons.close
                                  : widget.data.status == PjpStatusType.done
                                      ? Icons.check
                                      : Icons.add_chart_sharp,
                      // Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
            ),
            onTap: () {
              togglePanel();
            },
            title: LangText("${widget.data.date?.toString().dayMonthYear}"),
            subtitle: LangText(widget.data.category ?? ''),
            trailing: Transform.rotate(
              angle: animation!.value * math.pi / 180,
              child: const Icon(
                CupertinoIcons.chevron_down,
                size: 18,
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: animationView!,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    border: Border(
                        top:
                            BorderSide(width: 1, color: grey.withOpacity(0.2))),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1, color: grey.withOpacity(0.2))),
                              margin: const EdgeInsets.only(top: 18),
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8, top: 26),
                              child: Column(
                                children: [
                                  _information(
                                    title: "Schedule",
                                    details: "${widget.data.morningDepName}",
                                  ),
                                  const SizedBox(height: 10),
                                  _information(
                                    title: "Customer",
                                    details:
                                        "${widget.data.morningCustomerName}",
                                  ),
                                  const SizedBox(height: 10),
                                  _information(
                                    title: "In time",
                                    details: widget.data.inTime
                                            ?.toString()
                                            .hourlyDateFormat ??
                                        "-",
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  width: 1,
                                  color: grey.withOpacity(0.2),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sunny,
                                    color: yellow,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  LangText("Morning schedule"),
                                ],
                              ),
                            ),

                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    width: 1,
                                    color: grey.withOpacity(0.2),
                                  ),
                                  color: Colors.white,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    redirectSrToGoogleMap(widget.data.morningLat??0, widget.data.morningLong??0);
                                  },
                                  child: const Icon(
                                    Icons.location_on,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1, color: grey.withOpacity(0.2))),
                              margin: const EdgeInsets.only(top: 18),
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8, top: 26),
                              child: Column(
                                children: [
                                  _information(
                                    title: "Schedule",
                                    details: "${widget.data.eveningDepName}",
                                  ),
                                  const SizedBox(height: 10),
                                  _information(
                                    title: "Customer",
                                    details:
                                        "${widget.data.eveningCustomerName}",
                                  ),
                                  const SizedBox(height: 10),
                                  _information(
                                    title: "Out time",
                                    details: widget.data.outTime
                                            ?.toString()
                                            .hourlyDateFormat ??
                                        "-",
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  width: 1,
                                  color: grey.withOpacity(0.2),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.dark_mode,
                                    color: yellow,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  LangText("Evening schedule"),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    width: 1,
                                    color: grey.withOpacity(0.2),
                                  ),
                                  color: Colors.white,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    redirectSrToGoogleMap(widget.data.eveningLat??0, widget.data.eveningLong??0);
                                  },
                                  child: const Icon(
                                    Icons.location_on,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.data.status == PjpStatusType.missed &&
                      widget.data.remark == null,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 1, color: grey.withOpacity(0.2))),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: GlobalWidgets().showInfoFlex(
                              message: 'Explain why you missed the schedule'),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        TextButton(
                          onPressed: widget.onTap,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryRed,
                          ),
                          child: LangText("Explain"),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.data.remark != null,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(width: 1, color: grey.withOpacity(0.2))),
                    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _information(
                          title: "Remark",
                          details: "${widget.data.remark}",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // LangText("29 August 2024", style: Theme.of(context).textTheme.labelLarge,),
        ],
      ),
    );
  }

  void togglePanel() {
    if (!expand) {
      controller!.forward();
    } else {
      controller!.reverse();
    }
    expand = !expand;
  }

  Widget _information({
    required String title,
    required String details,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: LangText(
            title,
            style: TextStyle(color: grey.withOpacity(0.7)),
          ),
        ),
        const SizedBox(width: 8),
        LangText(
          ":",
          style: TextStyle(color: grey.withOpacity(0.7)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: LangText(details),
        )
      ],
    );
  }

  redirectSrToGoogleMap(double lat, double long) async {
    Alerts(context: context).floatingLoading();
    // LocationData? srLocation = await locationService.determinePosition();
    // log("retailer location: lat-> ${retailerModel?.lat} long-> ${retailerModel?.lng}");

    final location =  await LocationService(context).determinePosition();

    if(location!=null) {
      await LocationService(context).openMapDirections(
        destinationLat: lat,
        destinationLong: long,
        sourceLat: location.latitude??0,
        sourceLong: location.longitude??0,
      );
    }

    navigatorKey.currentState?.pop();
  }
}
