import 'package:espa_admin/models/korisnikUloga.dart';
import 'package:espa_admin/providers/base_provider.dart';

class KorisnikUlogaProvider extends BaseProvider<KorisnikUloga> {
  KorisnikUlogaProvider(): super("KorisnikUloga");

   @override
  KorisnikUloga fromJson(data) {
    // TODO: implement fromJson
    return KorisnikUloga.fromJson(data);
  }
}