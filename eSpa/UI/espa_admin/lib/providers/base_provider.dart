import 'dart:convert';

import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    /* _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://localhost:7031/");*/
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5031/");
  }

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
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

  Future<List<dynamic>> getUslugeProsjecneOcjene() async {
    /* if (endpoint != 'Ocjena') {
    throw Exception("Ova metoda se koristi samo za 'Ocjena' entitet.");
  }*/

    var url = "$_baseUrl$_endpoint/UslugeProsjecneOcjene";
    print("URL: $url");
    var uri = Uri.parse(url);
    print("URI: $uri");

    var headers = createHeaders(); // ako koristiš autorizaciju
    var response = await http.get(uri, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      print("response.status code ${response.statusCode}");
      throw Exception("Greška prilikom dohvaćanja prosječnih ocjena.");
    }
  }

  Future<List<dynamic>> getRezervacijePoUslugama() async {
    /* if (endpoint != 'Ocjena') {
    throw Exception("Ova metoda se koristi samo za 'Ocjena' entitet.");
  }*/

    var url = "$_baseUrl$_endpoint/RezervacijePoUslugama";
    print("URL: $url");
    var uri = Uri.parse(url);
    print("URI: $uri");

    var headers = createHeaders(); // ako koristiš autorizaciju
    var response = await http.get(uri, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      print("response.status code ${response.statusCode}");
      throw Exception("Greška prilikom dohvaćanja prosječnih ocjena.");
    }
  }

  Future<List<T>> getListFromEndpoint(String endpoint) async {
    var url = "$_baseUrl$_endpoint/$endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        return data.map((item) => fromJson(item)).toList();
      } else {
        throw Exception("Nepodržan format odgovora: očekivana lista.");
      }
    } else {
      throw Exception(
          "Greška pri preuzimanju podataka: ${response.statusCode}");
    }
  }

  Future getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await http.get(uri, headers: headers);
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
    var response = await http.post(uri, headers: headers, body: jsonRequest);

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
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<bool> delete(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await http.delete(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      // Ako je odgovor false, znači nešto nije u redu
      if (data == false) {
        throw Exception("Ne postoji novost sa datim ID-om.");
      }

      notifyListeners();
      return data; // Vraćamo true ako je uspešno obrisano
    } else {
      throw Exception("Nepoznata greška.");
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

    print("passed creds: $username, $password");

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

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

  Future<void> blokirajKorisnika(int korisnikId) async {
    var url =
        "${_baseUrl}Korisnici/Blokiraj/$korisnikId"; // ili 'blokiraj?id=$korisnikId' zavisno od backend rute
    var uri = Uri.parse(url);
    var headers = createHeaders();

    print("Pozivam: $url");

    var response = await http.post(uri, headers: headers);

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      print("Korisnik je uspješno blokiran.");
    } else {
      var responseBody = json.decode(response.body);
      if (response.statusCode == 400 && responseBody['message'] != null) {
        throw Exception(responseBody['message']);
      } else {
        throw Exception("Greška pri blokiranju korisnika.");
      }
    }
  }
}
