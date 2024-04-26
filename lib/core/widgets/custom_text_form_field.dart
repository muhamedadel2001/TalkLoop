import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final String? initialValue;
  final IconData? prefixIcon;
  final String? hintText;
  final String labelName;
  final String? Function(String?)? onSaved;
  final String? Function(String?) ?validator;
  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.prefixIcon,
    this.hintText,
    required this.labelName, this.onSaved, this.validator,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator:validator,
      initialValue: initialValue,
      decoration: InputDecoration(
          label: Text(labelName),
          labelStyle: const TextStyle(color: Colors.white),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
              borderSide: BorderSide(color: Colors.grey.shade500)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
              borderSide: BorderSide(color: Colors.grey.shade500))),
    );
  }
}
