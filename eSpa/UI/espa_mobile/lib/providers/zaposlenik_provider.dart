import 'package:espa_mobile/models/zaposlenik.dart';
import 'package:espa_mobile/providers/base_provider.dart';


class ZaposlenikProvider extends BaseProvider<Zaposlenik> {
  ZaposlenikProvider(): super("Zaposlenik");

   @override
  Zaposlenik fromJson(data) {
    // TODO: implement fromJson
    return Zaposlenik.fromJson(data);
  }
}