import 'package:espa_admin/models/zaposlenik.dart';
import 'package:espa_admin/providers/base_provider.dart';


class ZaposlenikProvider extends BaseProvider<Zaposlenik> {
  ZaposlenikProvider(): super("Zaposlenik");

   @override
  Zaposlenik fromJson(data) {
    // TODO: implement fromJson
    return Zaposlenik.fromJson(data);
  }
}