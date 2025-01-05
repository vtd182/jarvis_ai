import 'package:jarvis_ai/core/helpers/loading_helper.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/retrofit/rest_error.dart';
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
      final errorCode = error.getHeader('X-Error-Code');
      await handleRestError(error, errorCode);
    } else {
      showToast(error.toString());
    }
    return unit;
  }

  Future<Unit> handleRestError(RestError restError, String? errorCode) async {
    switch (errorCode) {
      default:
        showToast(restError.getError());
        break;
    }
    return unit;
  }
}
