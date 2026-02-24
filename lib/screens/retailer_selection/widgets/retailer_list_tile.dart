import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/language_textbox.dart';

// class RetailerListTile extends StatelessWidget {
//   final OutletModel retailer;
//   final Function()? onItemTap;
//   final Function()? onInfoTap;
//   final Function()? onMapTap;
//   final Color? backgroundColor;
//   final bool? navigationTileEnabled;
//
//   const RetailerListTile({
//     super.key,
//     required this.retailer,
//     required this.onItemTap,
//     this.onInfoTap,
//     this.onMapTap,
//     this.backgroundColor,
//     this.navigationTileEnabled,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 2.h),
//       child: InkWell(
//         onTap: onItemTap,
//         child: Container(
//           clipBehavior: Clip.hardEdge,
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: const BorderRadius.all(Radius.circular(10)),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(
//                     right: 12, left: 12, top: 16, bottom: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _titleValue(title: 'Retailer', value: retailer.owner),
//                     const SizedBox(height: 4),
//                     _titleValue(title: 'Store Name', value: retailer.name),
//                     const SizedBox(height: 4),
//                     _titleValue(
//                       title: 'Contact',
//                       value: retailer.contact ?? '',
//                       valueColor: primary,
//                     ),
//                     const SizedBox(height: 4),
//                     _titleValue(title: 'Code', value: retailer.outletCode ?? "--"),
//                     const SizedBox(height: 4),
//                     _titleValue(title: 'Address', value: retailer.address ?? ""),
//                     Visibility(
//                       visible: retailer.cluster != null && retailer.cluster?.slug != null,
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 4),
//                           _titleValue(title: 'Cluster', value: retailer.cluster?.slug ?? ""),
//                         ],
//                       ),
//                     ),
//
//                     Visibility(
//                       visible: retailer.totalSale >= 0.0,
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 4),
//                           _titleValue(
//                             title: 'Sale',
//                             value: retailer.totalSale.toStringAsFixed(2),
//                             valueColor: darkGreen,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//
//                     /// Navigation tile
//                     Visibility(
//                       visible: navigationTileEnabled == true,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Expanded(
//                             child: SizedBox(),
//                             // child: Wrap(
//                             //   // crossAxisAlignment: CrossAxisAlignment.center,
//                             //   children: List.generate(
//                             //     retailer.iconData.length,
//                             //     (index) => Padding(
//                             //       padding: const EdgeInsets.only(right: 4),
//                             //       child: (retailer.iconData[index].runtimeType == String)
//                             //           ? Padding(
//                             //               padding: const EdgeInsets.all(4.0),
//                             //               child: AssetService(context).superImage(
//                             //                 retailer.iconData[index],
//                             //                 folder: 'icon_images',
//                             //                 isIcon: true,
//                             //               ),
//                             //             )
//                             //           : Container(),
//                             //     ),
//                             //   ),
//                             // ),
//                           ),
//                           const SizedBox(width: 16),
//                           InkResponse(
//                             onTap: onInfoTap,
//                             child: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 color: Colors.lightBlueAccent,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: const Icon(
//                                 Icons.info_outline,
//                                 color: Colors.white,
//                                 size: 16,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 14),
//                           InkResponse(
//                             onTap: onMapTap,
//                             child: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 color: retailer.outletLocation.latitude != 0 &&
//                                         retailer.outletLocation.longitude != 0
//                                     ? Colors.lightBlueAccent
//                                     : Colors.blueGrey.withValues(alpha: .5),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: const Icon(
//                                 Icons.near_me_outlined,
//                                 color: Colors.white,
//                                 size: 16,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   Visibility(
//                     visible: retailer.preorderExists,
//                     child: Expanded(
//                       child: Container(
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color:  preorderColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Visibility(
//                     visible: retailer.spotSalesExists,
//                     child: Expanded(
//                       child: Container(
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: spotSalesColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _titleValue({
//     required String title,
//     required String value,
//     Color valueColor = Colors.black,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           flex: 1,
//           child: LangText(
//             title,
//             style: const TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         LangText(
//           ' : ',
//           style: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           flex: 2,
//           child: LangText(
//             value.isEmpty ? '* * * * * * *' : value,
//             style: TextStyle(
//               color: valueColor,
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//               // fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class RetailerListTile extends StatelessWidget {
  final OutletModel retailer;
  final Function()? onItemTap;
  final Function()? onInfoTap;
  final Function()? onMapTap;
  // final Color? backgroundColor;
  final bool? navigationTileEnabled;

  const RetailerListTile({
    super.key,
    required this.retailer,
    required this.onItemTap,
    this.onInfoTap,
    this.onMapTap,
    // this.backgroundColor,
    this.navigationTileEnabled,
  });

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey;
      case 'WORKFLOW_ERROR':
        return Colors.deepOrange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasLocation =
        retailer.outletLocation.latitude != 0 &&
        retailer.outletLocation.longitude != 0;

    final statusColor = _getStatusColor(retailer.outletStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onItemTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Name & Sale Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            retailer.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if (retailer.outletStatus != null && retailer.outletStatus!.isNotEmpty && retailer.outletStatus != 'APPROVED')
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: statusColor.withOpacity(0.2),
                              ),
                            ),
                            child: LangText(
                              _getStatus(retailer.outletStatus ?? ""),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: statusColor.withOpacity(0.9),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Owner Name
                    _buildIconText(
                      Icons.person_outline_rounded,
                      retailer.owner.isEmpty ? 'Unknown Owner' : retailer.owner,
                      iconColor: Colors.blue[300],
                    ),
                    const SizedBox(height: 6),

                    // Contact
                    _buildIconText(
                      Icons.phone_outlined,
                      retailer.contact ?? 'No Contact',
                      iconColor: Colors.orange[300],
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 6),

                    // Address
                    _buildIconText(
                      Icons.location_on_outlined,
                      retailer.address ?? 'No Address',
                      iconColor: Colors.red[300],
                      maxLines: 2,
                    ),
                    const SizedBox(height: 6),

                    // Chips (Code & Cluster)
                    if (retailer.outletCode != null ||
                        retailer.cluster?.slug != null) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          if (retailer.outletCode != null)
                            _buildChip(
                              retailer.outletCode!,
                              Colors.grey[100]!,
                              Colors.grey[800]!,
                              icon: Icons.qr_code,
                            ),
                          if (retailer.cluster?.slug != null) ...[
                            const SizedBox(width: 8),
                            _buildChip(
                              retailer.cluster!.slug!,
                              Colors.blue.withOpacity(0.05),
                              Colors.blue[800]!,
                              icon: Icons.group_work_outlined,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Bottom Action Bar (Navigation Tile)
              if (navigationTileEnabled == true)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status Dots
                      Row(
                        children: [
                          if (retailer.preorderExists)
                            _buildStatusDot("Pre-order", Colors.orange),
                          if (retailer.preorderExists &&
                              retailer.spotSalesExists)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              height: 12,
                              width: 1,
                              color: Colors.grey[300],
                            ),
                          if (retailer.spotSalesExists)
                            _buildStatusDot("Sale", Colors.blue),
                          if (retailer.hasZeroSales)
                            _buildStatusDot("Zero sale", Colors.redAccent),
                        ],
                      ),

                      // Action Buttons
                      Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.info_outline_rounded,
                            label: "Info",
                            onTap: onInfoTap,
                            isActive: true,
                          ),
                          const SizedBox(width: 12),
                          _buildActionButton(
                            icon: Icons.near_me_rounded,
                            label: "Map",
                            onTap: hasLocation ? onMapTap : null,
                            isActive: hasLocation,
                            isPrimary: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Simple Status Line if Navigation Tile is disabled
              if (navigationTileEnabled != true &&
                  (retailer.preorderExists || retailer.spotSalesExists))
                Row(
                  children: [
                    if (retailer.preorderExists)
                      Expanded(
                        child: Container(height: 3, color: Colors.orange),
                      ),
                    if (retailer.spotSalesExists)
                      Expanded(child: Container(height: 3, color: Colors.blue)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(
    IconData icon,
    String text, {
    Color? color,
    Color? iconColor,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 16, color: iconColor ?? Colors.grey[400]),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: color ?? Colors.grey[700],
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color bg, Color text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: text.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: text.withOpacity(0.6)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Function()? onTap,
    bool isActive = false,
    bool isPrimary = false,
  }) {
    Color contentColor = isActive
        ? (isPrimary ? Colors.white : Colors.grey[700]!)
        : Colors.grey[400]!;
    Color bgColor = isActive
        ? (isPrimary ? Colors.blue[600]! : Colors.white)
        : Colors.grey[200]!;
    Color borderColor = isActive && !isPrimary
        ? Colors.grey[300]!
        : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
            boxShadow: isActive && !isPrimary
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: contentColor),
              if (isPrimary && isActive) ...[
                const SizedBox(width: 4),
                LangText(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: contentColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDot(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        LangText(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getStatus(String status) {
    if(status == "PENDING") {
      return "UNVERIFIED";
    }
    return status;
  }
}
