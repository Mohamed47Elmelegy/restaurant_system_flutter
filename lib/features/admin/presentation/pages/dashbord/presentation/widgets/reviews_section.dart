import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/theme/theme_helper.dart';
import '../../../../../../../core/theme/text_styles.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: ThemeHelper.getCardShadow(context),
      ),
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Reviews', style: AppTextStyles.senRegular14(context)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All Reviews',
                  style: AppTextStyles.senRegular14(
                    context,
                  ).copyWith(color: Color(0xFFFB6D3A)),
                ),
              ),
            ],
          ),
          Row(
            spacing: 7.w,
            children: [
              Icon(Icons.star, color: Color(0xFFFB6D3A)),
              Text(
                '4.9',
                style: AppTextStyles.senBold22(
                  context,
                ).copyWith(color: Color(0xFFFB6D3A)),
              ),
              Text(
                'Total 20 Reviews',
                style: AppTextStyles.senRegular14(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
