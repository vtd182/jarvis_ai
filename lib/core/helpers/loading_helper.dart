import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LoadingHelper {
  int _loaderCount = 0;

  Future<void> showLoading() async {
    if (_loaderCount == 0) {
      await EasyLoading.show(
        status: "Loading...",
        maskType: EasyLoadingMaskType.black,
      );
    }
    _loaderCount++;
  }

  Future<void> hideLoading() async {
    if (_loaderCount == 1) {
      await EasyLoading.dismiss();
    }
    if (_loaderCount > 0) {
      _loaderCount--;
    }
  }

  Future<void> clear() async {
    _loaderCount = 0;
    await EasyLoading.dismiss();
  }
}
