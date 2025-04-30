import 'package:espa_mobile/models/uloga.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'korisnikUloga.g.dart';

@JsonSerializable()
class KorisnikUloga {
  int? id;
  int? korisnikId;
  int? ulogaId;
  Uloga? uloga;
  KorisnikUloga(
      this.id, this.korisnikId, this.ulogaId, this.uloga);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory KorisnikUloga.fromJson(Map<String, dynamic> json) =>
      _$KorisnikUlogaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KorisnikUlogaToJson(this);
}
