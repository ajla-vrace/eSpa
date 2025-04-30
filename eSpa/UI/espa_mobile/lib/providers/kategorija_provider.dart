import 'package:espa_mobile/models/kategorija.dart';
import 'package:espa_mobile/providers/base_provider.dart';

class KategorijaProvider extends BaseProvider<Kategorija> {
  KategorijaProvider(): super("Kategorija");

   @override
  Kategorija fromJson(data) {
    // TODO: implement fromJson
    return Kategorija.fromJson(data);
  }
}