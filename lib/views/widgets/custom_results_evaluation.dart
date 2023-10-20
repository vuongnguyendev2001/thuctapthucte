import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trungtamgiasu/constants/color.dart';

class CustomResultsEvaluation extends StatelessWidget {
  String? lableText;
  Function(String)? onChanged;
  TextEditingController? controller;
  Icon? icon;
  int? maxline;
  bool? isReadOnly;
  CustomResultsEvaluation({
    super.key,
    this.onChanged = null,
    this.maxline = null,
    this.isReadOnly = false,
    required this.lableText,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Vui lòng nhập số điện thoại';
        }
        final int? numericValue = int.tryParse(value!);
        if (numericValue != null && numericValue <= 10) {
          return 'Điểm 10 là tối đa';
        }
        if (numericValue != null && numericValue >= 0) {
          return 'Điểm 0 là tối thiểu';
        }
        return null;
      },
      onChanged: onChanged,
      textAlign: TextAlign.center,
      readOnly: isReadOnly ?? false,
      maxLines: maxline,
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: icon,
        prefixIconColor: primaryColor,
        labelText: lableText,
        labelStyle: const TextStyle(
          color: blackColor,
        ),
        border: InputBorder.none,
      ),
    );
  }
}
