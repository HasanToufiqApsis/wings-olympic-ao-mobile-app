import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';

class RetailerDetailsScreen extends ConsumerStatefulWidget {
  static const routeName = 'RetailerDetailsScreen';
  final OutletModel retailer;

  const RetailerDetailsScreen({
    super.key,
    required this.retailer,
  });

  @override
  ConsumerState<RetailerDetailsScreen> createState() => _RetailerDetailsScreenState();
}

class _RetailerDetailsScreenState extends ConsumerState<RetailerDetailsScreen> {
  final GlobalWidgets globalWidgets = GlobalWidgets();

  List<int> sectionIds = [];

  @override
  void initState() {
    sectionIds = [widget.retailer.sectionId ?? 0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncLeaveModel = ref.watch(retailerImageProvider(widget.retailer.outlet_cover_image??""));
    return Scaffold(
      appBar: CustomAppBar(
        title: "Retailer",
        showLeading: true,
      ),
      body: asyncLeaveModel.when(
          data: (leaveData) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 3.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                        Radius.circular(verificationRadius),
                      ),
                      image: DecorationImage(
                        image: widget.retailer.outletCoverImage == null || widget.retailer.outletCoverImage?.image == null || (widget.retailer.outletCoverImage?.image.isEmpty ?? false)
                            ? const AssetImage("assets/placeholder.png")
                            : widget.retailer.outletCoverImage?.imageType == ImageType.file
                            ? FileImage(
                          File(
                            widget.retailer.outletCoverImage?.image ?? "",
                          ),
                        )
                            : NetworkImage(
                          widget.retailer.outletCoverImage?.image ?? "",
                        ) as ImageProvider,
                        // : AssetImage("assets/retailer_image.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 18, bottom: 8),
                    child: LangText(
                      "Outlet Details",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        _titleValueNew(
                          title: "Retailer",
                          value: widget.retailer.owner,
                          icon: Icons.person_2_rounded,
                        ),
                        _titleValueNew(
                          title: "Store Name",
                          value: widget.retailer.name,
                          icon: Icons.storefront_outlined,
                        ),
                        _titleValueNew(
                          title: "Contact",
                          value: widget.retailer.contact ?? "",
                          icon: Icons.call_outlined,
                        ),
                        _titleValueNew(
                          title: "Retailer Code",
                          value: widget.retailer.outletCode ?? "",
                          icon: Icons.document_scanner_outlined,
                        ),
                        _titleValueNew(
                          title: "Address",
                          value: widget.retailer.address ?? "",
                          icon: Icons.location_on_outlined,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 18, bottom: 8),
                    child: LangText(
                      "Others Information",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Consumer(builder: (context, ref, _) {
                          final asyncPromotions = ref.watch(promotionListProvider(
                              widget.retailer.availablePromotions));
                          return asyncPromotions.when(
                            data: (promotions) {
                              return _titleValueNew(
                                title: "Promotion",
                                value: promotions.length.toString(),
                                icon: Icons.local_offer_outlined,
                              );
                            },
                            error: (error, stck) {
                              return _titleValue(title: 'Promotions', value: '0');
                            },
                            loading: () {
                              return _titleValue(title: 'Promotions', value: '0');
                            },
                          );
                        }),
                        _titleValueNew(
                            title: 'Survey',
                            value: widget.retailer.availableSurvey.length.toString(),
                            icon: Icons.assignment_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, _) {
            return Center(
              child: LangText("Nothing to see"),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          )),
    );
  }

  Widget _titleValue({
    required String title,
    required String value,
    Color valueColor = Colors.black,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: LangText(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        LangText(
          ' : ',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 2,
          child: LangText(
            value.isEmpty ? '* * * * * * *' : value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              // fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleValueNew({
    required String title,
    required String value,
    required IconData icon,
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[400],
            ),
            padding: EdgeInsets.all(6),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LangText(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.grey),
                ),
                LangText(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          )
        ],
      ),
    );
    return ListTile(
      title: LangText(
        title,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      subtitle: LangText(
        value,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () {},
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[400],
        ),
        padding: EdgeInsets.all(6),
        child: Icon(
          Icons.translate_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
