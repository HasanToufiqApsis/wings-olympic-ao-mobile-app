import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/point_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/digital_learning_controller.dart';

class AuditUI extends ConsumerStatefulWidget {
  const AuditUI({Key? key}) : super(key: key);
  static const routeName = "/audit_ui";

  @override
  ConsumerState<AuditUI> createState() => _AuditUIState();
}

class _AuditUIState extends ConsumerState<AuditUI> {
  final _appBarTitle = DashboardBtnNames.audit;
  late DigitalLearningController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DigitalLearningController(context: context, ref: ref);
    _controller.onControllerInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: CustomAppBar(
          title: _appBarTitle,
          heroTagTitle: _appBarTitle,
          // heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
          titleImage: "audit.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          }),
      body: Consumer(builder: (context, ref, _) {
        final asyncPointList = ref.watch(getAllPointsProvider);

        return asyncPointList.when(
            data: (requestList) {
              if (requestList.isEmpty) {
                return _EmptyState(
                  onRetry: () => ref.invalidate(getAllPointsProvider),
                );
              }

              return RefreshIndicator(
                color: primary,
                onRefresh: () async {
                  ref.invalidate(getAllPointsProvider);
                },
                child: ListView.separated(
                  itemCount: requestList.length,
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  itemBuilder: (BuildContext context, int index) {
                    final point = requestList[index];
                    return _PointCard(
                      point: point,
                      onTap: () async {
                        await _controller.onPointLocationItemTap(point);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 1.2.h);
                  },
                ),
              );
            },
            error: (error, _) => _ErrorState(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(getAllPointsProvider),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ));
      }),
    );
  }
}

class _PointCard extends StatelessWidget {
  final PointDetailsModel point;
  final VoidCallback onTap;

  const _PointCard({
    required this.point,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surveys = point.availableSurveys?.length ?? 0;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: primary,
                  size: 22,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LangText(
                      point.name ?? 'Unnamed Point',
                      style: TextStyle(
                        fontSize: mediumFontSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF202124),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    LangText(
                      'Available Surveys: $surveys',
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[500], size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyState({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 56, color: Colors.grey[400]),
            SizedBox(height: 1.5.h),
            LangText(
              'No content available at this moment',
              style: TextStyle(color: Colors.grey[700], fontSize: mediumFontSize),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.5.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text('Refresh', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 56, color: Colors.red[300]),
            SizedBox(height: 1.5.h),
            LangText(
              'Failed to load points',
              style: TextStyle(
                color: const Color(0xFF202124),
                fontSize: mediumFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 0.8.h),
            LangText(
              message,
              style: TextStyle(color: Colors.grey[600], fontSize: smallFontSize),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.8.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
