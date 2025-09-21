import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_helper.dart';
import '../pages/meal_times/domain/entities/meal_time.dart';
import '../pages/meal_times/presentation/bloc/meal_time_state.dart';
import '../pages/meal_times/presentation/cubit/meal_time_cubit.dart';

class MealTimeSelector extends StatelessWidget {
  final Function(MealTime)? onMealTimeSelected;
  final bool showCurrentTimeIndicator;
  final EdgeInsetsGeometry? padding;

  const MealTimeSelector({
    super.key,
    this.onMealTimeSelected,
    this.showCurrentTimeIndicator = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealTimeCubit, MealTimeState>(
      builder: (context, state) {
        if (state is MealTimeLoading) {
          return _buildLoadingWidget();
        } else if (state is MealTimeError) {
          return _buildErrorWidget(context, state);
        } else if (state is MealTimesLoaded) {
          return _buildMealTimesList(context, state);
        } else if (state is MealTimeSelected) {
          return _buildMealTimesList(
            context,
            MealTimesLoaded(
              mealTimes: state.allMealTimes,
              currentMealTime: state.allMealTimes
                  .where((mt) => mt.isAvailableNow())
                  .firstOrNull,
            ),
            selectedMealTime: state.selectedMealTime,
          );
        }

        return _buildEmptyWidget();
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 60.h,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12.w),
          Text(
            'جاري تحميل أوقات الوجبات...',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, MealTimeError state) {
    return Container(
      height: 60.h,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              state.message,
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<MealTimeCubit>().refresh();
            },
            child: Text('إعادة المحاولة', style: TextStyle(fontSize: 12.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTimesList(
    BuildContext context,
    MealTimesLoaded state, {
    MealTime? selectedMealTime,
  }) {
    if (state.mealTimes.isEmpty) {
      return _buildEmptyWidget();
    }

    return Container(
      height: 60.h,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.mealTimes.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final mealTime = state.mealTimes[index];
          final isSelected = selectedMealTime?.id == mealTime.id;
          final isCurrent =
              showCurrentTimeIndicator &&
              state.currentMealTime?.id == mealTime.id;

          return _buildMealTimeChip(
            context,
            mealTime,
            isSelected: isSelected,
            isCurrent: isCurrent,
          );
        },
      ),
    );
  }

  Widget _buildMealTimeChip(
    BuildContext context,
    MealTime mealTime, {
    required bool isSelected,
    required bool isCurrent,
  }) {
    final primaryColor = ThemeHelper.getPrimaryColorForTheme(context);
    final backgroundColor = isSelected
        ? primaryColor
        : isCurrent
        ? primaryColor.withValues(alpha: 0.1)
        : ThemeHelper.getCardBackgroundColor(context);

    final textColor = isSelected
        ? Colors.white
        : isCurrent
        ? primaryColor
        : ThemeHelper.getPrimaryTextColor(context);

    final borderColor = isSelected
        ? primaryColor
        : isCurrent
        ? primaryColor
        : Colors.grey[300];

    return GestureDetector(
      onTap: () {
        context.read<MealTimeCubit>().selectMealTime(mealTime);
        onMealTimeSelected?.call(mealTime);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: borderColor ?? Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mealTime.getIcon(), style: TextStyle(fontSize: 16.sp)),
            SizedBox(width: 8.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealTime.getDisplayName(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
                if (mealTime.categoryIds.isNotEmpty)
                  Text(
                    '${mealTime.categoryIds.length} فئة',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
            if (isCurrent && !isSelected) ...[
              SizedBox(width: 8.w),
              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      height: 60.h,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: Text(
          'لا توجد أوقات وجبات متاحة',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
