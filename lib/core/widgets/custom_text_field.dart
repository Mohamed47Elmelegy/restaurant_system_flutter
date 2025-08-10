import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? isPassword;
  final String? hint;
  final bool? enabled;
  final int? maxLines, minLines, maxLength;
  final String? obscuringCharacter, value;
  final String? Function(String?)? onValidate;
  final void Function(String?)? onChanged, onFieldSubmitted, onSaved;
  final void Function()? onEditingComplete, onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixWidget, prefixIcon;
  final IconData? icon;
  final TextInputAction? action;
  final FocusNode? focusNode;
  final Color? hintColor;
  final Color? fillColor;
  final bool? filled;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? errorTextStyle;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double? borderWidth;
  final double? focusedBorderWidth;
  final double? errorBorderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Color? visibilityIconColor;
  final IconData? visibilityOnIcon;
  final IconData? visibilityOffIcon;
  final String? initialValue;

  const CustomTextField({
    super.key,
    this.controller,
    this.isPassword,
    this.hint,
    this.enabled,
    this.obscuringCharacter,
    this.value,
    this.onValidate,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onSaved,
    this.onTap,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.suffixWidget,
    this.icon,
    this.prefixIcon,
    this.action,
    this.focusNode,
    this.hintColor,
    this.fillColor,
    this.filled,
    this.textStyle,
    this.hintTextStyle,
    this.errorTextStyle,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderWidth,
    this.focusedBorderWidth,
    this.errorBorderWidth,
    this.borderRadius,
    this.contentPadding,
    this.visibilityIconColor,
    this.visibilityOnIcon,
    this.visibilityOffIcon,
    this.initialValue,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.value,
      validator: widget.onValidate,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      onTap: widget.onTap,
      maxLines: widget.isPassword ?? false ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      obscureText: widget.isPassword ?? false ? obscureText : false,
      obscuringCharacter: widget.obscuringCharacter ?? '*',
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      style:
          widget.textStyle ??
          AppTextStyles.senBold14(
            context,
          ).copyWith(color: AppColors.lightTextMain),
      textInputAction: widget.action ?? TextInputAction.done,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword ?? false
            ? InkWell(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child: Icon(
                  obscureText
                      ? (widget.visibilityOffIcon ?? Icons.visibility_off)
                      : (widget.visibilityOnIcon ?? Icons.visibility),
                  color:
                      widget.visibilityIconColor ??
                      AppColors.lightTextMain.withValues(alpha: 0.5),
                ),
              )
            : widget.suffixWidget,
        prefixIcon: widget.prefixIcon,
        hintText: widget.hint,
        fillColor: widget.fillColor ?? const Color(0xffF9FAFA),
        filled: widget.filled ?? true,
        hintStyle:
            widget.hintTextStyle ??
            AppTextStyles.senRegular14(context).copyWith(
              color:
                  widget.hintColor ??
                  AppColors.lightTextMain.withValues(alpha: 0.6),
            ),
        counterText: "",
        contentPadding: widget.contentPadding,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusedBorderColor ?? const Color(0xffE6E9EA),
            width: widget.focusedBorderWidth ?? 1.0,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: widget.borderWidth ?? 1.0,
            color: widget.borderColor ?? const Color(0xffE6E9EA),
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.0),
        ),
        errorStyle:
            widget.errorTextStyle ??
            const TextStyle(
              color: Colors.deepOrangeAccent,
              fontWeight: FontWeight.w400,
            ),
        errorMaxLines: 6,
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
          borderSide: BorderSide(
            color: widget.errorBorderColor ?? Colors.deepOrangeAccent,
            width: widget.errorBorderWidth ?? 1.0,
          ),
        ),
      ),
    );
  }
}
