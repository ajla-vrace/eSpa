import 'package:espa_admin/models/slikaProfila.dart';
import 'package:espa_admin/providers/base_provider.dart';


class SlikaProfilaProvider extends BaseProvider<SlikaProfila> {
  SlikaProfilaProvider(): super("SlikaProfila");

   @override
  SlikaProfila fromJson(data) {
    // TODO: implement fromJson
    return SlikaProfila.fromJson(data);
  }
}