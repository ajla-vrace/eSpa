import 'package:espa_admin/providers/base_provider.dart';

import '../models/statusRezervacije.dart';


class StatusRezervacijeProvider extends BaseProvider<StatusRezervacije> {
  StatusRezervacijeProvider(): super("StatusRezervacije");

   @override
  StatusRezervacije fromJson(data) {
    // TODO: implement fromJson
    return StatusRezervacije.fromJson(data);
  }
}