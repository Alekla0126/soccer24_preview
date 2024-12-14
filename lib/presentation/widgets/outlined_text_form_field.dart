import '../../constants/default_values.dart';
import '../../extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class OutlinedTextFormField extends StatelessWidget {
  const OutlinedTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.obscureText = false,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.maxLines = 1,
    this.enabled,
    this.radius,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool? enabled;
  final double? radius;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      maxLines: maxLines,
      style: context.textTheme.bodyLarge,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      decoration: InputDecoration(
        errorMaxLines: 2,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          vertical: DefaultValues.padding * 0.75,
          horizontal: DefaultValues.padding,
        ),
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? DefaultValues.radius/2),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? DefaultValues.radius/2),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? DefaultValues.radius/2),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? DefaultValues.radius/2),
          borderSide: BorderSide(
            color: context.colorScheme.error,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? DefaultValues.radius/2),
          borderSide: BorderSide(
            color: context.colorScheme.error,
            width: 1,
          ),
        ),
      ),
    );
  }
}