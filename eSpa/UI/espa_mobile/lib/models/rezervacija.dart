import 'package:espa_mobile/models/korisnik.dart';
import 'package:espa_mobile/models/termin.dart';
import 'package:espa_mobile/models/usluga.dart';
import 'package:espa_mobile/models/zaposlenik.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'rezervacija.g.dart';

@JsonSerializable()
class Rezervacija {
  int? id;
  int? korisnikId;
  int? uslugaId;
  DateTime? datum;
  int? terminId;
  int? zaposlenikId;
  String? status;
  Korisnik? korisnik;
  Usluga? usluga;
  Termin? termin;
  Zaposlenik? zaposlenik;
  Rezervacija(
      this.id,
      this.korisnikId,
      this.uslugaId,
      this.datum,
      this.terminId,
      this.zaposlenikId,
      this.status,
      this.korisnik,
      this.usluga,
      this.termin,
      this.zaposlenik);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Rezervacija.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RezervacijaToJson(this);
}
