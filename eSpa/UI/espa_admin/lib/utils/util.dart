class Authorization{
  static String? username;
  static String? password;
}
String _shortenText(String text, int maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength) + '...';
  }
  return text;
}
