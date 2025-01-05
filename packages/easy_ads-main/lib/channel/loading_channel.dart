import 'package:flutter/services.dart';

class LoadingChannel {
  static const loadingChannel = MethodChannel('loadingChannel');

  static void setMethodCallHandler(Function() onShowAd) =>
      loadingChannel.setMethodCallHandler(
        (call) async {
          switch (call.method) {
            case 'showAd':
              onShowAd();
              break;
            default:
              throw UnimplementedError();
          }
        },
      );

  static void closeAd() {
    loadingChannel.invokeMethod('closeAd');
    loadingChannel.setMethodCallHandler(null);
  }

  static void handleShowAd() {
    loadingChannel.invokeMethod('handleShowAd');
  }
}
