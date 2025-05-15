import 'dart:convert';
import 'dart:io';

import 'package:espa_mobile/models/search_result.dart';
import 'package:espa_mobile/models/usluga.dart';
import 'package:espa_mobile/utils/util.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";
  HttpClient client = HttpClient();
  IOClient? http;
  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    /*_baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7031/");*/
   /*_baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5031/");*/
        _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://192.168.1.6:5031/");
    // _baseUrl = const String.fromEnvironment("baseUrl",
    //defaultValue: "https://localhost:7031/");
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);
    // print("response body je ${response.body}");
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.count = data['count'];

      for (var item in data['result']) {
        // print("Item koji se parsira: $item");
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
    //print("response: ${response.request} ${response.statusCode}, ${response.body}");
  }

  Future<List<Usluga>> getRecommended(int uslugaId, int korisnikId) async {
    final url = Uri.parse('$_baseUrl'
        'Usluga/recommend/$uslugaId/$korisnikId');

    print("URL $url");

    //var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(url, headers: headers);
    // final response = await http!.get(url);

    print("RESPONSE $response   i status ${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Usluga.fromJson(json)).toList();
    } else {
      throw Exception('Greška pri dohvaćanju preporuka');
    }
  }

  Future getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }
/*
  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }
*/

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      var errorMessage = await _handleErrorResponse(response);
      throw Exception(errorMessage);
    }
  }

  Future<String> _handleErrorResponse(Response response) async {
    var data = jsonDecode(response.body);
    if (response.statusCode == 400 &&
        data['message'] == "Korisničko ime već postoji.") {
      return "Korisničko ime već postoji.";
    } else {
      return "Unknown error: ${data['message']}";
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<T> delete(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await http!.delete(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      notifyListeners();
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      print(response.body);
      throw new Exception("Something bad happened please try again");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";
/*String username="proba";
String password="proba";*/
    print("passed creds: $username, $password");

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    print("passed creds poslije: $username, $password");
    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }

  Future<void> changePassword(int userId, String currentPassword,
      String newPassword, String confirmPassword) async {
    //var url = "$_baseUrlKorisnici/ChangePassword"; // Ispravan URL
    // ignore: unused_local_variable
    var baseUrlWithoutSlash = _baseUrl!.endsWith('/')
        ? _baseUrl!.substring(0, _baseUrl!.length - 1)
        : _baseUrl;
    //var url = "$baseUrlWithoutSlash/Korisnici/ChangePassword";
    var url = "${_baseUrl}Korisnici/ChangePassword";

    var uri = Uri.parse(url);
    var headers = createHeaders();
    print("url $url");
    var jsonRequest = jsonEncode({
      "id": userId,
      "stariPassword": currentPassword,
      "noviPassword": newPassword,
      "potvrdaPassword": confirmPassword,
    });
    print("json $jsonRequest");
    var response = await http!.post(uri, headers: headers, body: jsonRequest);
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      print("Password changed successfully!");
    } else {
      var responseBody = json.decode(response.body);
      if (response.statusCode == 400 && responseBody['message'] != null) {
        throw Exception(responseBody['message']);
      } else {
        throw Exception("Unknown error");
      }
    }
  }

  
}
