import 'package:espa_admin/models/kategorija.dart';
import 'package:espa_admin/providers/base_provider.dart';

class KategorijaProvider extends BaseProvider<Kategorija> {
  KategorijaProvider(): super("Kategorija");

   @override
  Kategorija fromJson(data) {
    // TODO: implement fromJson
    return Kategorija.fromJson(data);
  }
}