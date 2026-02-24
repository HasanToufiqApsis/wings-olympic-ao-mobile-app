import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../constants/constant_variables.dart';
import '../../main.dart';
import '../language_textbox.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CustomAppBar({
//     Key? key,
//     this.titleImage,
//     this.subTitle,
//     this.actions,
//     this.centerTitle,
//     required this.title,
//     this.showLeading = true,
//     this.onLeadingIconPressed,
//     this.leadingIcon,
//     this.tab,
//     this.showTab,
//     this.heroTagTitle,
//     this.heroTagImg,
//   }) : super(key: key);
//
//   final String? titleImage;
//   final String title;
//   final String? subTitle;
//   final bool showLeading;
//   final VoidCallback? onLeadingIconPressed;
//   final IconData? leadingIcon;
//   final bool? centerTitle;
//   final List<Widget>? actions;
//   final TabBar? tab;
//   final bool? showTab;
//   final String? heroTagTitle;
//   final String? heroTagImg;
//
//   @override
//   Widget build(BuildContext context) {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(7.h),
//       child: Container(
//         color: Colors.white,
//         child: AppBar(
//           backgroundColor: Colors.transparent,
//           centerTitle: centerTitle ?? true,
//           automaticallyImplyLeading: showLeading,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: primaryGradient,
//             ),
//           ),
//           leading: showLeading
//               ? Padding(
//             padding:EdgeInsets.only(left: 3.w),
//             child: Container(
//               height: 7.h,
//               decoration: BoxDecoration(
//                   color: greenOlive.withOpacity(0.1),
//                   shape: BoxShape.circle
//               ),
//               child: Center(
//                 child: IconButton(
//                   onPressed: onLeadingIconPressed ??
//                           () {
//                         navigatorKey.currentState?.pop();
//                       },
//                   icon: Icon(
//                     Icons.arrow_back_rounded,
//                     size: 24,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           )
//               : null,
//           title: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               titleImage != null
//                   ? Padding(
//                     padding: EdgeInsets.only(right: 2.w),
//                     child: heroTagImg != null ? Hero(tag: heroTagImg ?? '', child: Image.asset("assets/$titleImage", height: 28, width: 28,)) : Image.asset("assets/$titleImage", height: 28, width: 28,),
//                   )
//                   : Container(),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   heroTagTitle != null ? Hero(
//                     tag: heroTagTitle ?? '',
//                     child: Material(
//                       color: Colors.transparent,
//                       child: LangText(
//                         title,
//                         style: TextStyle(
//                             color: primaryGrey,
//                             fontSize: mediumFontSize,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ) : LangText(
//                     title,
//                     style: TextStyle(
//                         color: primaryGrey,
//                         fontSize: mediumFontSize,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   if (subTitle != null)
//                     LangText(
//                       subTitle ?? "",
//                       style: TextStyle(
//                           color: primaryGrey, fontSize: smallerFontSize),
//                     ),
//                 ],
//               )
//             ],
//           ),
//           bottom:tab,
//           actions: actions,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(7.h);
// }



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.titleImage,
    required this.title,
    this.subTitle,
    this.actions,
    this.centerTitle,
    this.showLeading = true,
    this.onLeadingIconPressed,
    this.leadingIcon,
    this.tab,
    this.showTab,
    this.heroTagTitle,
    this.heroTagImg,

    // 🔍 Search related
    this.showSearch = false,
    this.searchController,
    this.onSearchChanged,
    this.searchHint,
    this.focusNode,
  }) : super(key: key);

  final String? titleImage;
  final String title;
  final String? subTitle;
  final bool showLeading;
  final VoidCallback? onLeadingIconPressed;
  final IconData? leadingIcon;
  final bool? centerTitle;
  final List<Widget>? actions;
  final TabBar? tab;
  final bool? showTab;
  final String? heroTagTitle;
  final String? heroTagImg;

  // 🔍 Search
  final bool showSearch;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final FocusNode? focusNode;
  final String? searchHint;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        color: Colors.white,
        child: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: centerTitle ?? true,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: primaryGradient,
            ),
          ),
          leading: showLeading ? _buildLeading() : null,
          title: showSearch ? _buildSearchBar() : _buildTitle(),
          bottom: tab,
          actions: actions,
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return Padding(
      padding: EdgeInsets.only(left: 3.w),
      child: Container(
        height: 7.h,
        decoration: BoxDecoration(
          color: greenOlive.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: IconButton(
            onPressed: onLeadingIconPressed ??
                    () {
                  navigatorKey.currentState?.pop();
                },
            icon: Icon(
              leadingIcon ?? Icons.arrow_back_rounded,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // 🏷 Normal Title View
  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (titleImage != null)
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: heroTagImg != null
                ? Hero(
              tag: heroTagImg!,
              child: Image.asset(
                "assets/$titleImage",
                height: 28,
                width: 28,
              ),
            )
                : Image.asset(
              "assets/$titleImage",
              height: 28,
              width: 28,
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            heroTagTitle != null
                ? Hero(
              tag: heroTagTitle!,
              child: Material(
                color: Colors.transparent,
                child: LangText(
                  title,
                  style: TextStyle(
                    color: primaryGrey,
                    fontSize: mediumFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
                : LangText(
              title,
              style: TextStyle(
                color: primaryGrey,
                fontSize: mediumFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subTitle != null)
              LangText(
                subTitle!,
                style: TextStyle(
                  color: primaryGrey,
                  fontSize: smallerFontSize,
                ),
              ),
          ],
        ),
      ],
    );
  }

  // 🔍 Search Bar View
  Widget _buildSearchBar() {
    return Container(
      height: 5.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Colors.white),
          hintText: searchHint ?? "Search...",
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(7.h);
}
