import 'package:espa_admin/models/zaposlenikSlike.dart';
import 'package:espa_admin/providers/base_provider.dart';


class ZaposlenikSlikeProvider extends BaseProvider<ZaposlenikSlike> {
  ZaposlenikSlikeProvider(): super("ZaposlenikSlike");

   @override
  ZaposlenikSlike fromJson(data) {
    // TODO: implement fromJson
    return ZaposlenikSlike.fromJson(data);
  }
}