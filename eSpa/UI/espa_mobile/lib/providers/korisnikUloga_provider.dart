import 'package:espa_mobile/models/korisnikUloga.dart';
import 'package:espa_mobile/providers/base_provider.dart';

class KorisnikUlogaProvider extends BaseProvider<KorisnikUloga> {
  KorisnikUlogaProvider(): super("KorisnikUloga");

   @override
  KorisnikUloga fromJson(data) {
    // TODO: implement fromJson
    return KorisnikUloga.fromJson(data);
  }
}