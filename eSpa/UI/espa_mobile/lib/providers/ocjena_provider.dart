import 'package:espa_mobile/models/ocjena.dart';
import 'package:espa_mobile/providers/base_provider.dart';

class OcjenaProvider extends BaseProvider<Ocjena> {
  OcjenaProvider(): super("Ocjena");

   @override
  Ocjena fromJson(data) {
    // TODO: implement fromJson
    return Ocjena.fromJson(data);
  }
}