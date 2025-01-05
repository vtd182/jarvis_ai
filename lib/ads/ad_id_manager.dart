import 'package:easy_ads_flutter/easy_ads_flutter.dart';

class AppAdIdManager extends IAdIdManager {
  String get admobAppId => "xxx";

  String get banner_all => "ca-app-pub-7943913974858898/9312245824";

  String get inter_knowledge_detail => "ca-app-pub-7943913974858898/3269613472";

  String get open_resume => "ca-app-pub-7943913974858898/5097668641";

  String get inter_create_prompt => "ca-app-pub-7943913974858898/2666978242";

  @override
  AppAdIds? get admobAdIds => AppAdIds(appId: admobAppId);

  @override
  AppAdIds? get appLovinAdIds => null;
}
