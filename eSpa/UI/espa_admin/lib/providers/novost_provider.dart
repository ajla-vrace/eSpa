import 'package:espa_admin/models/novost.dart';
import 'package:espa_admin/providers/base_provider.dart';

class NovostProvider extends BaseProvider<Novost> {
  NovostProvider(): super("Novost");

   @override
  Novost fromJson(data) {
    // TODO: implement fromJson
    return Novost.fromJson(data);
  }
}