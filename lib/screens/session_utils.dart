import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSession(String userId, String cookieSession, bool isAdmin) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', userId);
  prefs.setString('set-cookie', cookieSession);
  prefs.setBool('isAdmin', isAdmin);
}

Future<Map<String, dynamic>?> getSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString('userId');
  final String? cookieSession = prefs.getString('set-cookie');
  final bool? isAdmin = prefs.getBool('isAdmin');

  if (userId != null && isAdmin != null) {
    return {'userId': userId, 'set-cookie': cookieSession, 'isAdmin': isAdmin};
  }

  return null;
}

Future<String?> getSessionCookie() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('set-cookie');
}

Future<void> clearSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('userId');
}