import 'package:espa_admin/models/rezervacija.dart';
import 'package:espa_admin/providers/base_provider.dart';

class RezervacijaProvider extends BaseProvider<Rezervacija> {
  RezervacijaProvider(): super("Rezervacija");

   @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }
}