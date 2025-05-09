/*import 'dart:convert';

import 'package:espa_admin/models/ocjena.dart';
import 'package:espa_admin/models/uslugaOcjena.dart';
import 'package:espa_admin/providers/base_provider.dart';

class OcjenaProvider extends BaseProvider<Ocjena> {
  OcjenaProvider(): super("Ocjena");

   @override
  Ocjena fromJson(data) {
    // TODO: implement fromJson
    return Ocjena.fromJson(data);
  }
  // Dodajemo novu metodu koja poziva API i vraća listu usluga i njihovih prosečnih ocjena
  Future<List<UslugaOcjena>> getUslugeProsjecneOcjene() async {
    final response = await http.get(Uri.parse('http://localhost:5000/Ocjena/UslugeProsjecneOcjene'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => UslugaOcjena.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load usluge and prosjecne ocjene');
    }
  }
}*/

//import 'dart:convert';

import 'package:espa_admin/models/ocjena.dart';
//import 'package:espa_admin/models/uslugaOcjena.dart';
import 'package:espa_admin/providers/base_provider.dart';
//import 'package:http/http.dart' as http;
//import 'package:http/http.dart';

class OcjenaProvider extends BaseProvider<Ocjena> {
  OcjenaProvider() : super("Ocjena");

  // Metoda za preuzimanje prosječnih ocjena za sve usluge
  /* Future<List<UslugaOcjena>> getUslugeProsjecneOcjene() async {
    var url = Uri.parse('https://localhost:7031/Ocjena/UslugeProsjecneOcjene');
    var response = await http.get(url);
    print("response: $response");
    print("response status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => UslugaOcjena.fromJson(e)).toList();
    } else {
      throw Exception('Greška pri preuzimanju podataka');
    }
  }*/
  /*Future<List<UslugaOcjena>> getUslugeProsjecneOcjene() async {
    var podaci = await getListFromEndpoint("UslugeProsjecneOcjene");
    print("podaci ${podaci}");
    // Ručno castamo jer BaseProvider je tipiziran za Ocjena, a mi očekujemo UslugaOcjena
    return podaci
        .map((e) => UslugaOcjena.fromJson(e as Map<String, dynamic>))
        .toList();
  }*/

  @override
  Ocjena fromJson(data) {
    return Ocjena.fromJson(data);
  }
}
