import 'package:espa_mobile/models/usluga.dart';
import 'package:espa_mobile/providers/base_provider.dart';

class UslugaProvider extends BaseProvider<Usluga> {
  UslugaProvider(): super("Usluga");

   @override
  Usluga fromJson(data) {
    // TODO: implement fromJson
    return Usluga.fromJson(data);
  }
}