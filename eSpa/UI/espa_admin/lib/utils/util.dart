import 'package:shared_preferences/shared_preferences.dart';

class Authorization{
  static String? username;
  static String? password;
}
// ignore: unused_element
String _shortenText(String text, int maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength) + '...';
  }
  return text;
}
Future<void> setUserName(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}
Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}
class LoggedUser {
  static int? id;
  static String? ime;
  static String? prezime;
  static String? korisnickoIme;
  static bool? isBlokiran;
  static String? uloga;

  static void clear() {
    id = 0;
    ime = "";
    prezime = "";
    korisnickoIme = "";
    isBlokiran=false;
    uloga = "";
  }
}

