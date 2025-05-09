

import 'package:espa_mobile/models/favorit.dart';
import 'package:espa_mobile/providers/base_provider.dart';

class FavoritProvider extends BaseProvider<Favorit> {
  FavoritProvider(): super("Favorit");

   @override
  Favorit fromJson(data) {
    // TODO: implement fromJson
    return Favorit.fromJson(data);
  }
}