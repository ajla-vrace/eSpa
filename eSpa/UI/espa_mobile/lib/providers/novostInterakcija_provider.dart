import 'package:espa_mobile/models/novostInterakcija.dart';
import 'package:espa_mobile/providers/base_provider.dart';

class NovostInterakcijaProvider extends BaseProvider<NovostInterakcija> {
  NovostInterakcijaProvider(): super("NovostInterakcija");

   @override
  NovostInterakcija fromJson(data) {
    // TODO: implement fromJson
    return NovostInterakcija.fromJson(data);
  }
}