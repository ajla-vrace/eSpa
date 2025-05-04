import 'package:espa_admin/models/novostKomentar.dart';
import 'package:espa_admin/providers/base_provider.dart';

class NovostKomentarProvider extends BaseProvider<NovostKomentar> {
  NovostKomentarProvider(): super("NovostKomentar");

   @override
  NovostKomentar fromJson(data) {
    // TODO: implement fromJson
    return NovostKomentar.fromJson(data);
  }
}