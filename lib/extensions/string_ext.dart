import 'package:easy_localization/easy_localization.dart';

extension StringExt on String {
  String trans({List<String>? args, Map<String, String>? namedArgs, String? gender}) {
    return this.tr(args: args, namedArgs: namedArgs, gender: gender);
  }
}
