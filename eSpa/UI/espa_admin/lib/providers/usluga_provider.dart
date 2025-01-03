
import 'dart:convert';
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http;

class UslugaProvider with ChangeNotifier {
static String? _baseUrl;
String _endpoint = "Usluga";

UslugaProvider(){
_baseUrl = const String.fromEnvironment ("baseUrl", defaultValue: "https://localhost:7031/");
}

Future<dynamic> get() async{
var url = "$_baseUrl$_endpoint";
print("Request URL: $url"); // Debug ispis.
var uri= Uri.parse(url);
var headers = createHeaders();
var response = await http.get(uri, headers: headers);
print("response: ${response.statusCode}    ${response.request}");
var data=jsonDecode(response.body);

return data;
}

Map<String, String> createHeaders() {
String username = "neko";
String password = "neko";
String basicAuth = "Basic ${base64Encode(utf8.encode('$username:$password'))}";
print("Authorization: $basicAuth");

var headers = {
"Content-Type": "application/json",
"Authorization": basicAuth
};

return headers;
}
}