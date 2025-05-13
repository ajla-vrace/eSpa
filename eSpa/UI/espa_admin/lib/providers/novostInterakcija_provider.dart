import 'package:espa_admin/models/novostInterakcija.dart';
import 'package:espa_admin/providers/base_provider.dart';

class NovostInterakcijaProvider extends BaseProvider<NovostInterakcija> {
  NovostInterakcijaProvider(): super("NovostInterakcija");

   @override
  NovostInterakcija fromJson(data) {
    // TODO: implement fromJson
    return NovostInterakcija.fromJson(data);
  }
}