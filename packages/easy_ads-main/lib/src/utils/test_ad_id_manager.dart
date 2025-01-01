import 'package:easy_ads_flutter/easy_ads_flutter.dart';

class TestAdIdManager extends IAdIdManager {
  @override
  AppAdIds? get admobAdIds => const AppAdIds(appId: TestAdsId.admobAppId);
}
