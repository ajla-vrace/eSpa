import 'package:espa_admin/models/korisnik.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'zaposlenik.g.dart';

@JsonSerializable()
class Zaposlenik {
  int? id;
  int? korisnikId;
  DateTime? datumZaposlenja;
  String? struka;
  String? status;
  String? napomena;
  Korisnik? korisnik;
  Zaposlenik(this.id, this.korisnikId, this.datumZaposlenja, this.struka, this.status, this.napomena,this.korisnik);

    /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Zaposlenik.fromJson(Map<String, dynamic> json) => _$ZaposlenikFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ZaposlenikToJson(this);
}
