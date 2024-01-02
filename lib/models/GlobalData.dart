import 'package:http/http.dart';

class GlobalData{
 static const  String server = 'http://10.0.2.2:8080';
 static String cookie = '';

 static void updateCookieSession(Response response) {
  String? rawCookie = response.headers['set-cookie'];
  if (rawCookie != null) {
   int index = rawCookie.indexOf(';');
   cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
  }
 }
}