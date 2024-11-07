import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/core/helpers/loading_helper.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';

abstract class AppViewModel extends BaseViewModel {
  Future<Unit> showLoading() async {
    await locator<LoadingHelper>().showLoading();
    return unit;
  }

  Future<Unit> hideLoading() async {
    await locator<LoadingHelper>().hideLoading();
    return unit;
  }

  @override
  Future<Unit> handleError(dynamic error) async {
    if (error is RestError) {
      final errorCode = error.getHeader(Constants.errorCodeResponseHeader);
      await handleRestError(error, errorCode);
    } else {
      showToast(error.toString());
    }
    return unit;
  }

  Future<Unit> handleRestError(RestError restError, String? errorCode) async {
    switch (errorCode) {
      default:
        showToast(restError.getAllErrorWithString());
        break;
    }
    return unit;
  }
}
