import 'package:shared_preferences/shared_preferences.dart';
import 'package:shazam_vin/models/GlobalData.dart';
import 'package:http/http.dart' as http;

Future<void> saveSession(String userId,  bool isAdmin) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', userId);
  prefs.setBool('isAdmin', isAdmin);
}

Future<Map<String, dynamic>?> getSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString('userId');
  final bool? isAdmin = prefs.getBool('isAdmin');

  if (userId != null && isAdmin != null) {
    return {'userId': userId, 'isAdmin': isAdmin};
  }

  return null;
}

Future<void> clearSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  GlobalData.cookie = "";
  prefs.remove('userId');
  prefs.remove('isAdmin');
}
