import 'dart:math';

// ignore: avoid_classes_with_only_static_members
class StringHelper {
  static bool isNullOrEmpty(String? text) {
    if (text == null || text.isEmpty) return true;
    return false;
  }

  static String generateRandomString(int len) {
    final r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }
}
