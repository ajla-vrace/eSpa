import 'package:espa_admin/models/uloga.dart';
import 'package:espa_admin/providers/base_provider.dart';

class UlogaProvider extends BaseProvider<Uloga> {
  UlogaProvider(): super("Uloga");

   @override
  Uloga fromJson(data) {
    // TODO: implement fromJson
    return Uloga.fromJson(data);
  }
}