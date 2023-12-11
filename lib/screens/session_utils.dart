import 'package:shared_preferences/shared_preferences.dart';

// Fonction pour enregistrer la session
Future<void> saveSession(String userId, bool isAdmin) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', userId);
  prefs.setBool('isAdmin', isAdmin);
}

// Fonction pour récupérer la session
Future<Map<String, dynamic>?> getSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString('userId');
  final bool? isAdmin = prefs.getBool('isAdmin');

  if (userId != null && isAdmin != null) {
    return {'userId': userId, 'isAdmin': isAdmin};
  }

  return null;
}

// Fonction pour nettoyer la session localement
Future<void> clearSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('userId');
}