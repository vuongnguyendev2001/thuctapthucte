import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'enums/snack_bar_type.dart';

class UIHelper {
  /// Show Snack Bar
  static void showSnackBar({
    String title = 'alert',
    String? message,
    SnackBarType type = SnackBarType.success,
  }) {
    showFlushbar(message: message ?? '', snackBarType: type);
    // ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
    // final snackBar = SnackBar(
    //   content: Text(
    //     message ?? '',
    //     style: ShareStyles.normalStyle.copyWith(color: Colors.white),
    //   ),
    //   backgroundColor: type.getBGColor(),
    //   behavior: SnackBarBehavior.floating,
    // );
    // ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  static void showMaterialDialog({
    String title = 'alert',
    String message = '',
    bool isShowClose = false,
    String titleClose = 'close',
    bool isShowConfirm = true,
    String titleConfirm = 'confirm',
    VoidCallback? onComfirm,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title.tr),
          content: Text(message.tr),
          actions: <Widget>[
            if (isShowClose)
              TextButton(
                onPressed: () {
                  navigator!.pop();
                },
                child: Text(
                  titleClose.tr,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            if (isShowConfirm)
              TextButton(
                onPressed: onComfirm,
                child: Text(titleConfirm.tr),
              ),
          ],
        );
      },
    );
  }

  static void showCustomDialog({
    String title = 'alert',
    String message = '',
    bool isShowClose = false,
    String titleClose = 'close',
    bool isShowConfirm = true,
    String titleConfirm = 'confirm',
    VoidCallback? onComfirm,
  }) {
    if (GetPlatform.isIOS) {
      UIHelper.showCupertinoDialog(
          isShowClose: isShowClose,
          isShowConfirm: isShowConfirm,
          message: message,
          titleClose: titleClose,
          titleConfirm: titleConfirm,
          onComfirm: onComfirm);
      return;
    } else if (GetPlatform.isAndroid) {
      UIHelper.showMaterialDialog(
          isShowClose: isShowClose,
          isShowConfirm: isShowConfirm,
          titleClose: titleClose,
          titleConfirm: titleConfirm,
          message: message,
          onComfirm: onComfirm);
      return;
    }
  }

  static void showCupertinoDialog({
    String title = 'alert',
    String message = '',
    bool isShowClose = false,
    String titleClose = 'close',
    bool isShowConfirm = true,
    String titleConfirm = 'confirm',
    VoidCallback? onComfirm,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title.tr),
          content: Text(message.tr),
          actions: <Widget>[
            if (isShowClose)
              TextButton(
                onPressed: () {
                  navigator!.pop();
                },
                child: Text(
                  titleClose.tr,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            if (isShowConfirm)
              TextButton(
                onPressed: onComfirm,
                child: Text(titleConfirm.tr),
              ),
          ],
        );
      },
    );
  }

  /// Show FlushBar
  static void showFlushbar({
    required String message,
    IconData? iconData,
    SnackBarType snackBarType = SnackBarType.success,
    BuildContext? context,
  }) {
    Flushbar(
      message: message,
      icon: Icon(
        snackBarType.getIconData(),
        size: 20.0,
        color: snackBarType.getBGColor(),
      ),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(seconds: 3),
    ).show(context ?? Get.context!);
  }
}
