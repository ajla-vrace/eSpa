import 'package:espa_admin/models/korisnik.dart';
import 'package:espa_admin/providers/base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider(): super("Korisnici");

   @override
  Korisnik fromJson(data) {
    // TODO: implement fromJson
    return Korisnik.fromJson(data);
  }
}