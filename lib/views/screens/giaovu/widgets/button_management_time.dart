import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trungtamgiasu/constants/style.dart';

import '../../../../constants/color.dart';

class Button_Management_Time extends StatelessWidget {
  Function()? onTap;
  String? title;
  Icon? icon;
  Button_Management_Time({
    Key? key,
    this.onTap,
    this.title,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: whiteColor,
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        icon != null ? icon! : const SizedBox(),
                        icon != null
                            ? const SizedBox(width: 5)
                            : const SizedBox(),
                        Text(
                          title!,
                          style: Style.subtitleStyle,
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right_outlined,
                      size: 26,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
