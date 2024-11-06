import 'package:easy_localization/easy_localization.dart';
import 'package:santapocket/deeplink/type_deeplink.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_result.dart';
import 'package:santapocket/modules/user/domain/enums/user_type.dart';
import 'package:tiengviet/tiengviet.dart';

extension StringExt on String {
  String trans({List<String>? args, Map<String, String>? namedArgs, String? gender}) {
    return this.tr(args: args, namedArgs: namedArgs, gender: gender);
  }

  String splitString({required String start, required String end}) {
    final startIndex = indexOf(start);
    final endIndex = indexOf(end, startIndex + start.length);
    return substring(startIndex + start.length, endIndex);
  }

  TypeDeepLink parseType() {
    switch (this) {
      case "cabinet_info":
        return TypeDeepLink.CabinetInfo;
      case "momo_payment":
        return TypeDeepLink.MomoPayment;
      case "vnpay://sdk":
        return TypeDeepLink.VnPayPayment;
      case "charity_donation":
        return TypeDeepLink.CharityDonation;
      case "locker_info":
        return TypeDeepLink.LockerInfo;
      default:
        return TypeDeepLink.UnKnown;
    }
  }

  PaymentResult getResultPaymentMomo() {
    switch (this) {
      case "0":
      case "9000":
        return PaymentResult.success;
      case "10":
      case "7000":
        return PaymentResult.processing;
      case "99":
      case "1001":
      case "1002":
      case "1004":
      case "1006":
        return PaymentResult.error;
      default:
        return PaymentResult.error;
    }
  }

  PaymentResult getResultPaymentVnPay() {
    switch (this) {
      case "00":
        return PaymentResult.success;
      case "09":
      case "10":
      case "11":
      case "12":
      case "13":
      case "24":
      case "51":
      case "65":
      case "79":
      case "99":
        return PaymentResult.error;
      case "75":
        return PaymentResult.processing;
      default:
        return PaymentResult.error;
    }
  }

  String divideHundred() {
    return (int.parse(this) / 100).toString();
  }

  String removeVietnameseSign() => TiengViet.parse(this);

  bool match(String query) => removeVietnameseSign().toLowerCase().contains(query.removeVietnameseSign().toLowerCase());

  String removeWhitespaces() => replaceAll(RegExp('\\s+'), '');

  Language toLanguage() {
    switch (this) {
      case "en":
        return Language.en;
      case "vi":
        return Language.vi;
      default:
        return Language.unknown;
    }
  }

  UserType toUserType() {
    switch (this) {
      case "shipper":
        return UserType.shipper;
      case "receiver":
        return UserType.receiver;
      default:
        return UserType.defaultType;
    }
  }
}
