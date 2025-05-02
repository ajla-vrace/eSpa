import 'package:espa_mobile/models/zaposlenikRecenzija.dart';
import 'package:espa_mobile/providers/base_provider.dart';

class ZaposlenikRecenzijaProvider extends BaseProvider<ZaposlenikRecenzija> {
  ZaposlenikRecenzijaProvider(): super("ZaposlenikRecenzija");

   @override
  ZaposlenikRecenzija fromJson(data) {
    // TODO: implement fromJson
    return ZaposlenikRecenzija.fromJson(data);
  }
}