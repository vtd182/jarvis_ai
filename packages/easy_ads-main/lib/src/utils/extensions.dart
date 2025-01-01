import '../easy_ad_base.dart';
import '../enums/ad_network.dart';
import '../enums/ad_unit_type.dart';

extension EasyAdBaseListExtension on List<EasyAdBase> {
  bool doesNotContain(AdNetwork adNetwork, AdUnitType type) =>
      indexWhere((e) => e.adNetwork == adNetwork && e.adUnitType == type) == -1;
}
