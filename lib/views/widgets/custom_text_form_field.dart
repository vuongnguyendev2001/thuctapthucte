import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../constants/share_styles.dart';
import '../../constants/style.dart';

class CustomTextFormField extends StatelessWidget {
  /// MARK: - Initials;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final IconData? iconData;
  final bool? obscureText;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.iconData,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardsLite,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          focusedBorder: ShareStyles.defaultOutlineBorder,
          border: ShareStyles.defaultOutlineBorder,
          enabledBorder: ShareStyles.defaultOutlineBorder,
          disabledBorder: ShareStyles.defaultOutlineBorder,
          errorBorder: ShareStyles.defaultOutlineBorder,
          prefixIcon: Icon(iconData),
          hintText: hintText,
          hintStyle: Style.priceStyle,
          isDense: true,
        ),
        validator: validator,
      ),
    );
  }
}
