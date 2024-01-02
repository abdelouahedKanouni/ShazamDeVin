import 'package:http/http.dart';

class GlobalData{
 static const  String server = 'http://192.168.1.27:8080';
 static String cookie = '';

 static void updateCookieSession(Response response) {
  String? rawCookie = response.headers['set-cookie'];
  if (rawCookie != null) {
   int index = rawCookie.indexOf(';');
   cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
  }
 }
}