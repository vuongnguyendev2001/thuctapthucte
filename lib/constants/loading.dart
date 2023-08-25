import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:trungtamgiasu/constants/color.dart';

class Loading {
  void configLoading() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..loadingStyle = EasyLoadingStyle.custom
      ..progressColor = cardsLite
      ..backgroundColor = textBoxLite
      ..indicatorColor = primaryButtonColor
      ..textColor = blackColor
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  Future<void> isShowLoading() async {
    configLoading();
    await EasyLoading.show(
      status: 'Đang tải...',
      maskType: EasyLoadingMaskType.black,
    );
  }

  Future<void> isOffShowLoading() async {
    await EasyLoading.dismiss();
  }
}
