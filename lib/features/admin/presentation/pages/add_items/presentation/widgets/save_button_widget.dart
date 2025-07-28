import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';

class SaveButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SaveButtonWidget({
    super.key,
    required this.onPressed,
    this.text = 'SAVE CHANGES',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.lightPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 