

import 'package:espa_admin/models/komentar.dart';
import 'package:espa_admin/providers/base_provider.dart';

class KomentarProvider extends BaseProvider<Komentar> {
  KomentarProvider(): super("Komentar");

   @override
  Komentar fromJson(data) {
    // TODO: implement fromJson
    return Komentar.fromJson(data);
  }
}