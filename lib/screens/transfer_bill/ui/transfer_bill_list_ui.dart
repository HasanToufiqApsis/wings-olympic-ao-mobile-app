import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/models/transfer_bill_status.dart';
import 'package:wings_olympic_sr/provider/global_provider.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/dashboard_btn_names.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/returned_data_model.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../provider/transfer_bill_provider.dart';
import 'package:wings_olympic_sr/screens/transfer_bill/ui/transfer_bill_form_ui.dart';

class TransferBillListUI extends ConsumerWidget {
  const TransferBillListUI({Key? key}) : super(key: key);
  static const routeName = "/transfer_bill_list_ui";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(transferBillStatusProvider);
    final _appBarTitle = DashboardBtnNames.transferBill;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // মডার্ন হালকা ব্যাকগ্রাউন্ড
      appBar: CustomAppBar(
        title: _appBarTitle,
        titleImage: "bill.png",
        onLeadingIconPressed: () => Navigator.pop(context),
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, TransferBillFormUI.routeName),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        label: LangText("New Transfer Bill", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: statusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: LangText('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (data) {
          if (data.status == ReturnedStatus.success &&
              data.data != null &&
              data.data["success"] == true) {
            final model = TransferBillModel.fromJson(data.data);
            if (model.data!.isEmpty) {
              return _emptyState(context);
            }
            return ListView.separated(
              // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 80),
              itemCount: model.data!.length,
              separatorBuilder: (ctx, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = model.data![index];
                return _buildListItem(context, ref, item);
              },
            );
          } else {
            return _emptyState(context);
          }
        },
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.6,
              child: Image.asset('assets/not_found.png', height: 120),
            ),
            const SizedBox(height: 16),
            LangText(
              'No transfer bills found.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context,
      WidgetRef ref,
      TransferBillData data,
      ) {
    // স্ট্যাটাস কালার লজিক
    final status = data.status ?? 'N/A';
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          // -----------------------
          // Header: Date & Status
          // -----------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date Section
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    LangText(
                      data.transferDate ?? "",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                // Modern Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1), // হালকা ব্যাকগ্রাউন্ড
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: LangText(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Colors.grey[100]),
          ),

          // -----------------------
          // Body: Route Info
          // -----------------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Route Visual Line
                Column(
                  children: [
                    const Icon(Icons.circle, size: 12, color: Colors.blue),
                    Container(width: 2, height: 25, color: Colors.grey[200]),
                    Icon(Icons.location_on, size: 14, color: primary),
                  ],
                ),
                const SizedBox(width: 12),

                // Locations Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // From
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("From", style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                          LangText(
                            data.fromLocation ?? "Unknown",
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // To
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("To", style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                          LangText(
                            data.toLocation ?? "Unknown",
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // -----------------------
          // Footer: Amount
          // -----------------------
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text("Total Amount", style: TextStyle(fontSize: 13, color: Colors.black54)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                    ],
                  ),
                  child: LangText(
                    "৳ ${data.amount ?? '0'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
