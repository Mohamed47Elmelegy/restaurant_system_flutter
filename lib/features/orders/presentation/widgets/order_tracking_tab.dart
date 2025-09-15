import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../domain/entities/order_entity.dart';

class OrderTrackingTab extends StatelessWidget {
  final OrderEntity order;

  const OrderTrackingTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final trackingSteps = _generateTrackingSteps();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentStatus(context),
          SizedBox(height: 24.h),
          _buildTrackingTimeline(context, trackingSteps),
          SizedBox(height: 24.h),
          if (order.type == OrderType.delivery) _buildDeliveryInfo(context),
        ],
      ),
    );
  }

  Widget _buildCurrentStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  _getStatusIcon(order.status),
                  color: _getStatusColor(order.status),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusText(order.status),
                      style: AppTextStyles.senBold16(context).copyWith(
                        color: ThemeHelper.getPrimaryTextColor(context),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _getStatusDescription(order.status),
                      style: AppTextStyles.senRegular14(context).copyWith(
                        color: ThemeHelper.getSecondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(
    BuildContext context,
    List<TrackingStep> steps,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تتبع الطلب',
            style: AppTextStyles.senBold16(
              context,
            ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
          ),
          SizedBox(height: 16.h),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return _buildTimelineStep(context, step, isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    BuildContext context,
    TrackingStep step,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: step.isCompleted
                    ? AppColors.lightPrimary
                    : ThemeHelper.getSecondaryTextColor(
                        context,
                      ).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: step.isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color: step.isCompleted
                    ? AppColors.lightPrimary.withOpacity(0.3)
                    : ThemeHelper.getSecondaryTextColor(
                        context,
                      ).withOpacity(0.2),
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.senMedium14(context).copyWith(
                    color: step.isCompleted
                        ? ThemeHelper.getPrimaryTextColor(context)
                        : ThemeHelper.getSecondaryTextColor(context),
                  ),
                ),
                if (step.time != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    step.time!,
                    style: AppTextStyles.senRegular12(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                  ),
                ],
                if (step.description != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    step.description!,
                    style: AppTextStyles.senRegular12(context).copyWith(
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.delivery_dining,
                color: AppColors.lightPrimary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'معلومات التوصيل',
                style: AppTextStyles.senBold16(
                  context,
                ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildDeliveryRow(
            context,
            'العنوان',
            order.deliveryAddress ?? 'غير محدد',
          ),
          _buildDeliveryRow(context, 'الوقت المتوقع', '30-45 دقيقة'),
          _buildDeliveryRow(context, 'رقم التواصل', '+966 50 123 4567'),
        ],
      ),
    );
  }

  Widget _buildDeliveryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTextStyles.senMedium12(
                context,
              ).copyWith(color: ThemeHelper.getSecondaryTextColor(context)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.senRegular12(
                context,
              ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  List<TrackingStep> _generateTrackingSteps() {
    final now = DateTime.now();
    final steps = <TrackingStep>[];

    // Order placed
    steps.add(
      TrackingStep(
        title: 'تم استلام الطلب',
        description: 'تم تأكيد طلبك بنجاح',
        time: _formatTime(order.createdAt),
        isCompleted: true,
      ),
    );

    // Payment confirmed
    if (order.paymentStatus == PaymentStatus.paid) {
      steps.add(
        TrackingStep(
          title: 'تم تأكيد الدفع',
          description: 'تم استلام الدفع بنجاح',
          time: _formatTime(order.createdAt.add(const Duration(minutes: 2))),
          isCompleted: true,
        ),
      );
    }

    // Preparing
    if ([
      OrderStatus.preparing,
      OrderStatus.delivering,
      OrderStatus.completed,
    ].contains(order.status)) {
      steps.add(
        TrackingStep(
          title: 'قيد التحضير',
          description: 'المطعم يحضر طلبك الآن',
          time: order.status == OrderStatus.preparing
              ? null
              : _formatTime(order.updatedAt),
          isCompleted: [
            OrderStatus.delivering,
            OrderStatus.completed,
          ].contains(order.status),
        ),
      );
    }

    // Delivering (for delivery orders)
    if (order.type == OrderType.delivery &&
        [
          OrderStatus.delivering,
          OrderStatus.completed,
        ].contains(order.status)) {
      steps.add(
        TrackingStep(
          title: 'في الطريق إليك',
          description: 'المندوب في الطريق لتوصيل طلبك',
          time: order.status == OrderStatus.delivering
              ? null
              : _formatTime(order.updatedAt),
          isCompleted: order.status == OrderStatus.completed,
        ),
      );
    }

    // Completed
    if (order.status == OrderStatus.completed) {
      steps.add(
        TrackingStep(
          title: order.type == OrderType.delivery ? 'تم التوصيل' : 'تم التقديم',
          description:
              'تم ${order.type == OrderType.delivery ? 'توصيل' : 'تقديم'} طلبك بنجاح',
          time: _formatTime(order.updatedAt),
          isCompleted: true,
        ),
      );
    }

    return steps;
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.paid:
        return Colors.blue;
      case OrderStatus.preparing:
        return AppColors.lightPrimary;
      case OrderStatus.delivering:
        return Colors.purple;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.access_time;
      case OrderStatus.paid:
        return Icons.payment;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.delivering:
        return Icons.delivery_dining;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'في انتظار التأكيد';
      case OrderStatus.paid:
        return 'تم الدفع';
      case OrderStatus.preparing:
        return 'قيد التحضير';
      case OrderStatus.delivering:
        return 'في الطريق';
      case OrderStatus.completed:
        return 'مكتمل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }

  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'سيتم تأكيد طلبك قريباً';
      case OrderStatus.paid:
        return 'تم استلام الدفع وسيبدأ التحضير';
      case OrderStatus.preparing:
        return 'المطعم يحضر طلبك الآن';
      case OrderStatus.delivering:
        return 'المندوب في الطريق إليك';
      case OrderStatus.completed:
        return 'تم ${order.type == OrderType.delivery ? 'توصيل' : 'تقديم'} طلبك بنجاح';
      case OrderStatus.cancelled:
        return 'تم إلغاء الطلب';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class TrackingStep {
  final String title;
  final String? description;
  final String? time;
  final bool isCompleted;

  TrackingStep({
    required this.title,
    this.description,
    this.time,
    required this.isCompleted,
  });
}
