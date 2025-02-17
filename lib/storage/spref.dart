import 'package:jarvis_ai/storage/spref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPref {
  static final SPref instance = SPref._internal();

  SPref._internal();

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefKey.keyAccessToken);
  }

  Future setAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefKey.keyAccessToken, token);
  }

  Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefKey.keyRefreshToken);
  }

  Future saveRefreshToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefKey.keyRefreshToken, token);
  }

  Future setLocale(String locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("locale", locale);
  }

  Future<String?> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("locale");
  }

  Future<int?> getPermissionLastAsk() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("permissionNotificationLastAsk");
  }

  Future setPermissionLastAsk(int dateTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("permissionNotificationLastAsk", dateTime);
  }

  Future<int?> getPermissionAskTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("permissionNotificationAskTime");
  }

  Future setPermissionAskTime(int time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("permissionNotificationAskTime", time);
  }

  Future<int?> getExpiresAt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SPrefKey.keyExpiresAt);
  }

  Future setExpiresAt(int expiresAt) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SPrefKey.keyExpiresAt, expiresAt);
  }

  dynamic deleteAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final strLocale = prefs.getString('locale');
    await prefs.clear();
    if (strLocale != null) {
      await prefs.setString('locale', strLocale);
    }
  }

  // knowledge base
  Future<String?> getKBAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefKey.keyKBAccessToken);
  }

  Future setKBAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefKey.keyKBAccessToken, token);
  }

  Future<String?> getKBRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefKey.keyKBRefreshToken);
  }

  Future saveKBRefreshToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefKey.keyKBRefreshToken, token);
  }

  Future<int?> getKBExpiresAt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SPrefKey.keyKBExpiresAt);
  }

  Future setKBExpiresAt(int expiresAt) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SPrefKey.keyKBExpiresAt, expiresAt);
  }
}
