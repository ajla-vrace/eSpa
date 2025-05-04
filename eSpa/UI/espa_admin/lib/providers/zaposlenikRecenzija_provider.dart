import 'package:espa_admin/models/zaposlenikRecenzija.dart';
import 'package:espa_admin/providers/base_provider.dart';

class ZaposlenikRecenzijaProvider extends BaseProvider<ZaposlenikRecenzija> {
  ZaposlenikRecenzijaProvider(): super("ZaposlenikRecenzija");

   @override
  ZaposlenikRecenzija fromJson(data) {
    // TODO: implement fromJson
    return ZaposlenikRecenzija.fromJson(data);
  }
}