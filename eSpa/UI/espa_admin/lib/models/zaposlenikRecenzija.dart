import 'package:espa_admin/models/korisnik.dart';
import 'package:espa_admin/models/zaposlenik.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'zaposlenikRecenzija.g.dart';

@JsonSerializable()
class ZaposlenikRecenzija {
  int? id;
  String? komentar;
  int? ocjena;
  DateTime? datumKreiranja;
  int? zaposlenikId;
  int? korisnikId;
  Zaposlenik? zaposlenik;
  Korisnik? korisnik;
  ZaposlenikRecenzija(this.id, this.komentar, this.ocjena, this.datumKreiranja,
      this.zaposlenikId, this.korisnikId, this.zaposlenik, this.korisnik);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ZaposlenikRecenzija.fromJson(Map<String, dynamic> json) =>
      _$ZaposlenikRecenzijaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ZaposlenikRecenzijaToJson(this);
}
