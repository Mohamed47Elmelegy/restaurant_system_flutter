import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool> onChecked;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChecked,
  });

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
    });
    widget.onChecked(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 24.0.w,
        height: 24.0.h,
        decoration: BoxDecoration(
          color: _isChecked ? AppColors.lightPrimary : Colors.white,
          border: Border.all(
            color: _isChecked ? Colors.transparent : AppColors.lightBorder,
            width: 1.0.w,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: _isChecked
            ? const Icon(Icons.check, color: Colors.white, size: 16.0)
            : null,
      ),
    );
  }
}
