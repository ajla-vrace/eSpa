import 'package:espa_admin/models/termin.dart';
import 'package:espa_admin/providers/base_provider.dart';

class TerminProvider extends BaseProvider<Termin> {
  TerminProvider(): super("Termin");

   @override
  
  Termin fromJson(data) {
    // TODO: implement fromJson
    return Termin.fromJson(data);
  }
}